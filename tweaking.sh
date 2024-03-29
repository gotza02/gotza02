#!/usr/bin/env bash
# Written by Draco (tytydraco @ GitHub)

# The name of the current branch for logging purposes
BRANCH="throughput"

# Maximum unsigned integer size in C
UINT_MAX="4294967295"

# Duration in nanoseconds of one scheduling period
SCHED_PERIOD="$((10 * 1000 * 1000))"

# How many tasks should we have at a maximum in one scheduling period
SCHED_TASKS="6"

write() {
	# Bail out if file does not exist
	[[ ! -f "$1" ]] && return 1

	# Make file writable in case it is not already
	chmod +w "$1" 2> /dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi

	# Log the success
	echo "$1 → $2"
}

# Check for root permissions and bail if not granted
if [[ "$(id -u)" -ne 0 ]]
then
	echo "No root permissions. Exiting."
	exit 1
fi

# Detect if we are running on Android
grep -q android /proc/cmdline && ANDROID=true

# Log the date and time for records sake
echo "Time of execution: $(date)"
echo "Branch: $BRANCH"

# Sync to data in the rare case a device crashes
sync

# Limit max perf event processing time to this much CPU usage
write /proc/sys/kernel/perf_cpu_time_max_percent 50

# Sacrifice latency for throughput when grouping tasks
write /proc/sys/kernel/sched_autogroup_enabled 0

# Process child-parent forks naturally
write /proc/sys/kernel/sched_child_runs_first 0

# Preliminary requirement for the following values
write /proc/sys/kernel/sched_tunable_scaling 0

# Reduce the maximum scheduling period for lower latency
write /proc/sys/kernel/sched_latency_ns "$SCHED_PERIOD"

# Schedule this ratio of tasks in the guarenteed sched period
write /proc/sys/kernel/sched_min_granularity_ns "$((SCHED_PERIOD / SCHED_TASKS))"

# Require preeptive tasks to surpass half of a sched period in vmruntime
write /proc/sys/kernel/sched_wakeup_granularity_ns "$((SCHED_PERIOD / 2))"

# Reduce the frequency of task migrations
write /proc/sys/kernel/sched_migration_cost_ns 5000000

# Always allow sched boosting on top-app tasks
[[ "$ANDROID" == true ]] && write /proc/sys/kernel/sched_min_task_util_for_colocation 0

# Improve real time latencies by reducing the scheduler migration time
write /proc/sys/kernel/sched_nr_migrate 128

# Disable scheduler statistics to reduce overhead
write /proc/sys/kernel/sched_schedstats 0

# Disable unnecessary printk logging
write /proc/sys/kernel/printk_devkmsg off

# Start non-blocking writeback later
write /proc/sys/vm/dirty_background_ratio 30

# Start blocking writeback later
write /proc/sys/vm/dirty_ratio 50

# Require dirty memory to stay in memory for longer
write /proc/sys/vm/dirty_expire_centisecs 3000

# Run the dirty memory flusher threads less often
write /proc/sys/vm/dirty_writeback_centisecs 3000

# Disable read-ahead for swap devices
write /proc/sys/vm/page-cluster 0

# Update /proc/stat less often to reduce jitter
write /proc/sys/vm/stat_interval 10

# Swap to the swap device at a fair rate
write /proc/sys/vm/swappiness 100

# Allow inodes and dentries to build up a larger cache
write /proc/sys/vm/vfs_cache_pressure 80

# Enable Explicit Congestion Control
write /proc/sys/net/ipv4/tcp_ecn 1

# Enable fast socket open for receiver and sender
write /proc/sys/net/ipv4/tcp_fastopen 3

# Disable SYN cookies
write /proc/sys/net/ipv4/tcp_syncookies 0

if [[ -f "/sys/kernel/debug/sched_features" ]]
then
	# Consider scheduling tasks that are eager to run
	write /sys/kernel/debug/sched_features NEXT_BUDDY

	# Schedule tasks on their origin CPU if possible
	write /sys/kernel/debug/sched_features TTWU_QUEUE
fi

[[ "$ANDROID" == true ]] && if [[ -d "/dev/stune/" ]]
then
	# We are not concerned with prioritizing latency
	write /dev/stune/top-app/schedtune.prefer_idle 0

	# Mark top-app as boosted, find high-performing CPUs
	write /dev/stune/top-app/schedtune.boost 1
fi

# Loop over each CPU in the system
for cpu in /sys/devices/system/cpu/cpu*/cpufreq
do
	# Fetch the available governors from the CPU
	avail_govs="$(cat "$cpu/scaling_available_governors")"

	# Attempt to set the governor in this order
	for governor in performance interactive
	do
		# Once a matching governor is found, set it and break for this CPU
		if [[ "$avail_govs" == *"$governor"* ]]
		then
			write "$cpu/scaling_governor" "$governor"
			break
		fi
	done
done

# Apply governor specific tunables for performance
find /sys/devices/system/cpu/ -name performance -type d | while IFS= read -r governor
do
	# Consider changing frequencies once per scheduling period
	write "$governor/up_rate_limit_us" "$((SCHED_PERIOD / 1000))"
	write "$governor/down_rate_limit_us" "$((4 * SCHED_PERIOD / 1000))"
	write "$governor/rate_limit_us" "$((SCHED_PERIOD / 1000))"

	# Jump to hispeed frequency at this load percentage
	write "$governor/hispeed_load" 85
	write "$governor/hispeed_freq" "$UINT_MAX"
done

# Apply governor specific tunables for interactive
find /sys/devices/system/cpu/ -name interactive -type d | while IFS= read -r governor
do
	# Consider changing frequencies once per scheduling period
	write "$governor/timer_rate" "$((SCHED_PERIOD / 1000))"
	write "$governor/min_sample_time" "$((SCHED_PERIOD / 1000))"

	# Jump to hispeed frequency at this load percentage
	write "$governor/go_hispeed_load" 85
	write "$governor/hispeed_freq" "$UINT_MAX"
done

for queue in /sys/block/*/queue
do
	# Choose the first governor available
	avail_scheds="$(cat "$queue/scheduler")"
	for sched in cfq noop kyber bfq mq-deadline none
	do
		if [[ "$avail_scheds" == *"$sched"* ]]
		then
			write "$queue/scheduler" "$sched"
			break
		fi
	done

	# Do not use I/O as a source of randomness
	write "$queue/add_random" 0

	# Disable I/O statistics accounting
	write "$queue/iostats" 0

	# Sacrifice I/O and memory efficiency for a possible throughput gain
	write "$queue/read_ahead_kb" 256

	# Buffer more requests at once
	write "$queue/nr_requests" 512
done

# Always return success, even if the last write fails
exit 0

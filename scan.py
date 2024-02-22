import sys
import ipaddress
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
import signal

# Signal handler function
def signal_handler(signal_received, frame):
    # Custom message or actions before exiting
    print('\nReceived interrupt signal (Ctrl + C). Exiting gracefully...')
    sys.exit(0)

# Register the signal handler for SIGINT (Ctrl + C)
signal.signal(signal.SIGINT, signal_handler)

def is_valid_ip(ip: str) -> bool:
    """Check if the provided string is a valid IP address."""
    try:
        ipaddress.ip_address(ip)
        return True
    except ValueError:
        return False

def ip_to_num(ip: str) -> int:
    """Convert an IP address to its corresponding integer value."""
    return int(ipaddress.ip_address(ip))

def num_to_ip(num: int) -> str:
    """Convert an integer value to its corresponding IP address."""
    return str(ipaddress.ip_address(num))

def ping_ip(ip: str, ping_timeout: int) -> str:
    """Ping an IP address and return a simplified result."""
    try:
        subprocess.check_output(
            ["ping", "-n", "1", "-w", str(ping_timeout * 1), ip],
            stderr=subprocess.STDOUT,
            universal_newlines=True
        )
        return f"{ip},UP"
    except subprocess.CalledProcessError:
        return f"{ip},DOWN"
    except Exception as e:
        return f"{ip},ERROR,{str(e)}"

def scan_ips(start_ip: str, end_ip: str, output_file: str, concurrency: int, ping_timeout: int):
    """Scan a range of IP addresses by pinging them, saving only 'UP' statuses."""
    start_num = ip_to_num(start_ip)
    end_num = ip_to_num(end_ip)
    total_ips = end_num - start_num + 1
    if start_num > end_num:
        raise ValueError("Start IP must be less than or equal to End IP.")

    results = []
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = {executor.submit(ping_ip, num_to_ip(num), ping_timeout): num for num in range(start_num, end_num + 1)}
        for future in tqdm(as_completed(futures), total=total_ips, desc="Scanning IPs", unit="ip"):
            result = future.result()
            if "UP" in result:
                results.append(result)

    with open(output_file, 'w') as f_out:
        for result in results:
            print(result, file=f_out)
    print(f"Scan partially/fully complete, results saved in {output_file}")

def main():
    """Main function to parse arguments and initiate the IP scan."""
    if len(sys.argv) < 4:
        print("Usage: script.py start_ip end_ip output_file [concurrency] [ping_timeout]")
        sys.exit(1)

    start_ip, end_ip, output_file = sys.argv[1:4]
    concurrency = int(sys.argv[4]) if len(sys.argv) >= 5 else 10
    ping_timeout = int(sys.argv[5]) if len(sys.argv) == 6 else 1000

    if not is_valid_ip(start_ip) or not is_valid_ip(end_ip):
        print("Invalid IP address format.")
        sys.exit(1)

    scan_ips(start_ip, end_ip, output_file, concurrency, ping_timeout)

if __name__ == "__main__":
    main()

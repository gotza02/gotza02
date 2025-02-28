import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import asyncio
import aiohttp
import subprocess
import os
import sys
import psutil
import winreg
import shutil
import time
import threading
import socket
import json
import glob
import logging
import wmi
import urllib.request
import zipfile
import platform
import hashlib
import ctypes
import webbrowser
import sqlite3
import base64
import pickle
from datetime import datetime
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from typing import Dict, List, Optional, Callable
import multiprocessing as mp
from functools import partial
import signal

# Admin Check with Error Handling
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception as e:
        logging.error(f"Admin check failed: {e}")
        return False

if not is_admin():
    try:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit(0)
    except Exception as e:
        logging.error(f"Failed to elevate privileges: {e}")
        sys.exit(1)

# Configure Logging with Rotation
logging.basicConfig(
    filename='optimizer_log.txt',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
   .handlers=[logging.handlers.RotatingFileHandler('optimizer_log.txt', maxBytes=10*1024*1024, backupCount=5)]
)

# Database for Persistent Storage
DB_FILE = "optimizer_settings.db"
def init_db():
    try:
        conn = sqlite3.connect(DB_FILE, check_same_thread=False)
        c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value BLOB)''')
        c.execute('''CREATE TABLE IF NOT EXISTS schedules (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, interval INTEGER, last_run REAL)''')
        c.execute('''CREATE TABLE IF NOT EXISTS plugins (name TEXT PRIMARY KEY, path TEXT)''')
        conn.commit()
        return conn
    except sqlite3.Error as e:
        logging.error(f"Database initialization failed: {e}")
        raise

# Secure Encryption
SALT = b'optimizer_salt'
def get_cipher(password: str = "OptimizerPro2025"):
    kdf = PBKDF2HMAC(algorithm=hashes.SHA256(), length=32, salt=SALT, iterations=100000)
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return Fernet(key)

CIPHER = get_cipher()

# Main Application
class SystemOptimizer:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("System Optimizer Pro v4.0")
        self.root.geometry("1600x1000")
        self.root.resizable(True, True)
        self.loop = asyncio.new_event_loop()
        asyncio.set_event_loop(self.loop)
        self.process_pool = ProcessPoolExecutor(max_workers=mp.cpu_count())
        self.running = True

        # Variables
        self.dns_list: Dict[str, List[str]] = {
            "Google": ["8.8.8.8", "8.8.4.4"],
            "Cloudflare": ["1.1.1.1", "1.0.0.1"],
            "OpenDNS": ["208.67.222.222", "208.67.220.220"]
        }
        self.shodan_api_key: str = "YOUR_SHODAN_API_KEY"  # ใส่ API key จริง
        self.backup_dir: str = "backups"
        self.config_file: str = "optimizer_config.json"
        self.plugin_dir: str = "plugins"
        os.makedirs(self.backup_dir, exist_ok=True)
        os.makedirs(self.plugin_dir, exist_ok=True)
        self.db_conn = init_db()
        self.task_queue: asyncio.Queue = asyncio.Queue()

        # Style Configuration
        self.style = ttk.Style()
        self.style.theme_use("clam")
        self.style.configure("TButton", padding=8, font=("Segoe UI", 12), background="#0288D1", foreground="white")
        self.style.map("TButton", background=[("active", "#0277BD")])
        self.style.configure("TLabel", font=("Segoe UI", 12))
        self.style.configure("TNotebook", tabposition="n", background="#ECEFF1")
        self.style.configure("TNotebook.Tab", padding=[20, 10], font=("Segoe UI", 12, "bold"), background="#B0BEC5")
        self.style.map("TNotebook.Tab", background=[("selected", "#0288D1"), ("active", "#90CAF9")])

        # Main Frame with Dashboard
        self.main_frame = ttk.Frame(self.root)
        self.main_frame.pack(fill="both", expand=True)
        
        # Dashboard
        self.dashboard_frame = ttk.LabelFrame(self.main_frame, text="System Dashboard")
        self.dashboard_frame.pack(fill="x", padx=10, pady=5)
        self.cpu_var = tk.StringVar(value="CPU: 0%")
        self.ram_var = tk.StringVar(value="RAM: 0%")
        self.disk_var = tk.StringVar(value="Disk: 0%")
        ttk.Label(self.dashboard_frame, textvariable=self.cpu_var).pack(side="left", padx=10)
        ttk.Label(self.dashboard_frame, textvariable=self.ram_var).pack(side="left", padx=10)
        ttk.Label(self.dashboard_frame, textvariable=self.disk_var).pack(side="left", padx=10)

        # Scrollable Content
        self.canvas = tk.Canvas(self.main_frame)
        self.scrollbar = ttk.Scrollbar(self.main_frame, orient="vertical", command=self.canvas.yview)
        self.scrollable_frame = ttk.Frame(self.canvas)
        self.scrollable_frame.bind("<Configure>", lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))
        self.canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")
        self.canvas.configure(yscrollcommand=self.scrollbar.set)
        self.canvas.pack(side="left", fill="both", expand=True)
        self.scrollbar.pack(side="right", fill="y")

        # Tab Control
        self.tab_control = ttk.Notebook(self.scrollable_frame)
        self.tabs: Dict[str, ttk.Frame] = {
            "System": ttk.Frame(self.tab_control),
            "Network": ttk.Frame(self.tab_control),
            "Services": ttk.Frame(self.tab_control),
            "Cleanup": ttk.Frame(self.tab_control),
            "Hardware": ttk.Frame(self.tab_control),
            "Customization": ttk.Frame(self.tab_control),
            "Security": ttk.Frame(self.tab_control),
            "Automation": ttk.Frame(self.tab_control),
            "Premium": ttk.Frame(self.tab_control),
            "Advanced": ttk.Frame(self.tab_control),
            "Plugins": ttk.Frame(self.tab_control)
        }
        for name, tab in self.tabs.items():
            self.tab_control.add(tab, text=name)
        self.tab_control.pack(expand=1, fill="both", padx=10, pady=10)

        # Progress and Status
        self.progress = ttk.Progressbar(self.main_frame, length=1580, mode='indeterminate')
        self.progress.pack(pady=5)
        self.progress.pack_forget()
        self.status_var = tk.StringVar(value="Ready")
        self.status_label = ttk.Label(self.main_frame, textvariable=self.status_var, relief="sunken", anchor="w")
        self.status_label.pack(fill="x", padx=5, pady=2)
        self.style.configure("TLabel", background="#ECEFF1")

        # Setup UI
        self.setup_all_tabs()
        self.load_settings()

        # Start Background Tasks
        threading.Thread(target=self.run_event_loop, daemon=True).start()
        self.loop.create_task(self.update_dashboard())
        self.loop.create_task(self.run_background_tasks())

    # Event Loop for Asyncio
    def run_event_loop(self):
        while self.running:
            try:
                self.loop.run_forever()
            except Exception as e:
                logging.error(f"Event loop crashed: {e}")
                time.sleep(1)

    # Utility Methods
    async def async_run(self, func: Callable, *args, success_msg: str = "Operation completed!") -> Optional[str]:
        self.progress.pack()
        self.progress.start()
        self.status_var.set(f"Running {func.__name__.replace('_', ' ').title()}...")
        try:
            if asyncio.iscoroutinefunction(func):
                result = await func(*args)
            else:
                result = await self.loop.run_in_executor(self.process_pool, func, *args)
            self.status_var.set("Completed")
            logging.info(f"{func.__name__} completed: {result if result else 'Success'}")
            messagebox.showinfo("Success", success_msg)
            return result
        except Exception as e:
            self.status_var.set(f"Error: {str(e)}")
            logging.error(f"Error in {func.__name__}: {str(e)}")
            messagebox.showerror("Error", f"Failed: {str(e)}")
            raise
        finally:
            self.progress.stop()
            self.progress.pack_forget()
        return None

    def run_in_thread(self, func: Callable, *args, success_msg: str = "Operation completed!"):
        threading.Thread(target=lambda: self.loop.run_until_complete(self.async_run(func, *args, success_msg=success_msg)), daemon=True).start()

    def is_premium(self) -> bool:
        try:
            if not os.path.exists("license.key"):
                return False
            with open("license.key", "r") as f:
                key = f.read().strip()
            expected_hash = "your_license_hash"  # เปลี่ยนเป็น hash จริง
            return hashlib.sha256(key.encode()).hexdigest() == expected_hash
        except Exception as e:
            logging.error(f"License check failed: {e}")
            return False

    def save_setting(self, key: str, value: any):
        try:
            conn = self.db_conn
            c = conn.cursor()
            serialized = pickle.dumps(value)
            c.execute("INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)", (key, sqlite3.Binary(serialized)))
            conn.commit()
        except sqlite3.Error as e:
            logging.error(f"Failed to save setting {key}: {e}")

    def get_setting(self, key: str, default: any = None) -> any:
        try:
            conn = self.db_conn
            c = conn.cursor()
            c.execute("SELECT value FROM settings WHERE key = ?", (key,))
            result = c.fetchone()
            return pickle.loads(result[0]) if result else default
        except (sqlite3.Error, pickle.PickleError) as e:
            logging.error(f"Failed to get setting {key}: {e}")
            return default

    def load_settings(self):
        theme = self.get_setting("theme", "light")
        if theme == "dark":
            self.toggle_theme("dark")

    # Setup All Tabs
    def setup_all_tabs(self):
        self.setup_system_tab()
        self.setup_network_tab()
        self.setup_services_tab()
        self.setup_cleanup_tab()
        self.setup_hardware_tab()
        self.setup_customization_tab()
        self.setup_security_tab()
        self.setup_automation_tab()
        self.setup_premium_tab()
        self.setup_advanced_tab()
        self.setup_plugins_tab()

    # System Tab
    def setup_system_tab(self):
        frame = ttk.LabelFrame(self.tabs["System"], text="System Performance")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Optimize System", self.optimize_system, "System optimized successfully"),
            ("Enable UTC Time", self.enable_utc, "UTC time enabled"),
            ("Edit System Paths", self.edit_system_paths, "Paths edited"),
            ("Power Plan Customization", self.customize_power_plan_gui, "Power plan customized"),
            ("Resource Usage Monitor", self.resource_monitor_gui, "Monitoring started"),
            ("Boot Time Optimizer", self.optimize_boot_time, "Boot time optimized")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def optimize_system(self):
        psutil.Process().nice(psutil.HIGH_PRIORITY_CLASS)
        subprocess.run("powercfg -setactive SCHEME_MIN", shell=True, check=True, timeout=10)
        ctypes.windll.kernel32.SetProcessWorkingSetSize(-1, -1, -1)
        await asyncio.sleep(0.1)  # Prevent race condition
        return "System Optimized"

    async def enable_utc(self):
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\TimeZoneInformation", 
                          0, winreg.KEY_SET_VALUE) as key:
            winreg.SetValueEx(key, "RealTimeIsUniversal", 0, winreg.REG_DWORD, 1)
        return "UTC Enabled"

    async def edit_system_paths(self):
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Session Manager\Environment", 
                          0, winreg.KEY_ALL_ACCESS) as key:
            paths, _ = winreg.QueryValueEx(key, "Path")
        path_file = os.path.join(self.backup_dir, f"system_paths_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(path_file, "w") as f:
            f.write(paths)
        subprocess.Popen(f"notepad.exe {path_file}")
        await asyncio.sleep(1)
        return "Paths Edited"

    async def customize_power_plan_gui(self):
        power_window = tk.Toplevel(self.root)
        power_window.title("Power Plan Customization")
        power_window.geometry("400x300")
        ttk.Label(power_window, text="Select Power Plan:").pack(pady=5)
        plan_var = tk.StringVar(value="High Performance")
        plans = ["High Performance", "Balanced", "Power Saver"]
        for plan in plans:
            ttk.Radiobutton(power_window, text=plan, variable=plan_var, value=plan).pack(pady=2)
        ttk.Button(power_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.customize_power_plan(plan_var.get()))).pack(pady=10)

    async def customize_power_plan(self, plan: str):
        plans = {"High Performance": "SCHEME_MIN", "Balanced": "SCHEME_BALANCED", "Power Saver": "SCHEME_MAX"}
        subprocess.run(f"powercfg -setactive {plans[plan]}", shell=True, check=True, timeout=10)
        return "Power Plan Customized"

    async def resource_monitor_gui(self):
        mon_window = tk.Toplevel(self.root)
        mon_window.title("Resource Monitor")
        mon_window.geometry("800x600")
        tree = ttk.Treeview(mon_window, columns=("Name", "PID", "CPU", "RAM"), show="headings")
        tree.heading("Name", text="Process Name")
        tree.heading("PID", text="PID")
        tree.heading("CPU", text="CPU %")
        tree.heading("RAM", text="RAM MB")
        tree.pack(fill="both", expand=True)
        ttk.Button(mon_window, text="Kill Selected", 
                  command=lambda: self.run_in_thread(lambda: self.kill_process(tree.item(tree.selection())["values"][1]))).pack(pady=5)

        async def update_monitor():
            while mon_window.winfo_exists():
                for item in tree.get_children():
                    tree.delete(item)
                for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_info']):
                    try:
                        tree.insert("", "end", values=(proc.name(), proc.pid, f"{proc.cpu_percent():.1f}", 
                                                      f"{proc.memory_info().rss / 1024**2:.1f}"))
                    except:
                        pass
                await asyncio.sleep(2)
            self.loop.create_task(update_monitor())  # Restart if closed unexpectedly

        self.loop.create_task(update_monitor())
        return "Monitor Started"

    async def kill_process(self, pid: str):
        try:
            proc = psutil.Process(int(pid))
            proc.kill()
            return f"Killed PID {pid}"
        except psutil.NoSuchProcess:
            raise Exception(f"Process {pid} not found")

    async def optimize_boot_time(self):
        subprocess.run("bcdedit /set {current} bootmenupolicy legacy", shell=True, check=True, timeout=10)
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Session Manager\Power", 
                          0, winreg.KEY_SET_VALUE) as key:
            winreg.SetValueEx(key, "HiberbootEnabled", 0, winreg.REG_DWORD, 0)
        return "Boot Optimized"

    # Network Tab
    def setup_network_tab(self):
        frame = ttk.LabelFrame(self.tabs["Network"], text="Network Management")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Flush DNS", self.flush_dns, "DNS cache flushed"),
            ("Ping Test", self.ping_test_gui, "Ping test completed"),
            ("Change DNS", self.change_dns_gui, "DNS changed"),
            ("Search SHODAN", self.search_shodan, "SHODAN query completed"),
            ("Network Speed Test", self.network_speed_test, "Speed test completed"),
            ("Wi-Fi Analyzer", self.wifi_analyzer, "Wi-Fi analysis completed"),
            ("VPN Quick Setup", self.vpn_setup_gui, "VPN configured"),
            ("Network Traffic Monitor", self.network_traffic_monitor_gui, "Traffic monitoring started")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def flush_dns(self):
        subprocess.run("ipconfig /flushdns", shell=True, check=True, timeout=5)
        return "DNS Flushed"

    async def ping_test_gui(self):
        ping_window = tk.Toplevel(self.root)
        ping_window.title("Ping Test")
        ping_window.geometry("500x400")
        ttk.Label(ping_window, text="Enter IP/Domain:").pack(pady=5)
        ip_var = tk.StringVar(value="8.8.8.8")
        ttk.Entry(ping_window, textvariable=ip_var).pack(pady=5)
        result_text = tk.Text(ping_window, height=15)
        result_text.pack(pady=5, fill="both", expand=True)
        ttk.Button(ping_window, text="Ping", 
                  command=lambda: self.run_in_thread(lambda: self.ping_test(ip_var.get(), result_text))).pack(pady=5)

    async def ping_test(self, ip: str, result_widget: tk.Text):
        result = subprocess.run(f"ping -n 4 {ip}", shell=True, capture_output=True, text=True, check=True, timeout=10)
        result_widget.delete(1.0, tk.END)
        result_widget.insert(tk.END, result.stdout)
        return f"Pinged {ip}"

    async def change_dns_gui(self):
        dns_window = tk.Toplevel(self.root)
        dns_window.title("Change DNS")
        dns_window.geometry("400x300")
        ttk.Label(dns_window, text="Select DNS Server:").pack(pady=5)
        dns_var = tk.StringVar(value="Google")
        adapter_var = tk.StringVar()
        adapters = subprocess.run("netsh interface show interface", shell=True, capture_output=True, text=True).stdout.splitlines()
        adapter_list = [line.split()[-1] for line in adapters if "Connected" in line]
        ttk.Combobox(dns_window, textvariable=adapter_var, values=adapter_list).pack(pady=5)
        for name in self.dns_list:
            ttk.Radiobutton(dns_window, text=name, variable=dns_var, value=name).pack(pady=2)
        ttk.Button(dns_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.change_dns(adapter_var.get(), dns_var.get()))).pack(pady=10)

    async def change_dns(self, adapter: str, dns_name: str):
        dns = self.dns_list[dns_name]
        subprocess.run(f'netsh interface ip set dns "{adapter}" static {dns[0]}', shell=True, check=True, timeout=10)
        subprocess.run(f'netsh interface ip add dns "{adapter}" {dns[1]} index=2', shell=True, check=True, timeout=10)
        await self.flush_dns()
        return f"DNS Changed to {dns_name} on {adapter}"

    async def search_shodan(self):
        async with aiohttp.ClientSession() as session:
            ip = socket.gethostbyname(socket.gethostname())
            url = f"https://api.shodan.io/shodan/host/{ip}?key={self.shodan_api_key}"
            async with session.get(url, timeout=aiohttp.ClientTimeout(total=15)) as response:
                if response.status == 200:
                    data = await response.text()
                    with open(os.path.join(self.backup_dir, f"shodan_{ip}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"), "w") as f:
                        f.write(data)
                    webbrowser.open(os.path.join(self.backup_dir, f"shodan_{ip}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"))
                    return "SHODAN Queried"
                raise Exception(f"SHODAN API failed: {response.status}")

    async def network_speed_test(self):
        async with aiohttp.ClientSession() as session:
            start = time.time()
            async with session.get("http://speedtest.ftp.otenet.gr/files/test10mb.db") as response:
                await response.read()
            elapsed = time.time() - start
            speed = (10 / elapsed)  # MB/s
            messagebox.showinfo("Speed Test", f"Download Speed: {speed:.2f} MB/s\nLatency: {elapsed:.2f}s")
            return f"Speed: {speed:.2f} MB/s"

    async def wifi_analyzer(self):
        result = subprocess.run("netsh wlan show networks mode=bssid", shell=True, capture_output=True, text=True, check=True, timeout=10)
        output_file = os.path.join(self.backup_dir, f"wifi_scan_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(result.stdout)
        webbrowser.open(output_file)
        return "Wi-Fi Analyzed"

    async def vpn_setup_gui(self):
        vpn_window = tk.Toplevel(self.root)
        vpn_window.title("VPN Quick Setup")
        vpn_window.geometry("500x400")
        ttk.Label(vpn_window, text="VPN Configuration:").pack(pady=5)
        server_var = tk.StringVar(value="vpn.example.com")
        username_var = tk.StringVar()
        password_var = tk.StringVar()
        ttk.Label(vpn_window, text="Server:").pack(pady=2)
        ttk.Entry(vpn_window, textvariable=server_var).pack(pady=2)
        ttk.Label(vpn_window, text="Username:").pack(pady=2)
        ttk.Entry(vpn_window, textvariable=username_var).pack(pady=2)
        ttk.Label(vpn_window, text="Password:").pack(pady=2)
        ttk.Entry(vpn_window, textvariable=password_var, show="*").pack(pady=2)
        ttk.Button(vpn_window, text="Connect", 
                  command=lambda: self.run_in_thread(lambda: self.setup_vpn(server_var.get(), username_var.get(), password_var.get()))).pack(pady=10)

    async def setup_vpn(self, server: str, username: str, password: str):
        subprocess.run(f"rasdial \"Optimizer VPN\" {username} {password} /PHONE:{server}", shell=True, check=True, timeout=20)
        return "VPN Connected"

    async def network_traffic_monitor_gui(self):
        traffic_window = tk.Toplevel(self.root)
        traffic_window.title("Network Traffic Monitor")
        traffic_window.geometry("800x600")
        tree = ttk.Treeview(traffic_window, columns=("Name", "Sent", "Received"), show="headings")
        tree.heading("Name", text="Process Name")
        tree.heading("Sent", text="Sent (KB)")
        tree.heading("Received", text="Received (KB)")
        tree.pack(fill="both", expand=True)

        async def update_traffic():
            traffic = {}
            while traffic_window.winfo_exists():
                for proc in psutil.process_iter(['pid', 'name', 'net_io_counters']):
                    try:
                        net = proc.net_io_counters()
                        traffic[proc.name()] = (net.bytes_sent / 1024, net.bytes_recv / 1024)
                    except:
                        pass
                for item in tree.get_children():
                    tree.delete(item)
                for name, (sent, recv) in traffic.items():
                    tree.insert("", "end", values=(name, f"{sent:.2f}", f"{recv:.2f}"))
                await asyncio.sleep(2)
            self.loop.create_task(update_traffic())

        self.loop.create_task(update_traffic())
        return "Traffic Monitoring Started"

    # Services Tab
    def setup_services_tab(self):
        frame = ttk.LabelFrame(self.tabs["Services"], text="Service Management")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Disable Telemetry", self.disable_telemetry, "Telemetry disabled"),
            ("Disable Cortana", self.disable_cortana, "Cortana disabled"),
            ("Disable Office Telemetry", self.disable_office_telemetry, "Office telemetry disabled"),
            ("Disable CoPilot", self.disable_copilot, "CoPilot disabled"),
            ("Stop Windows Updates", self.stop_updates, "Updates stopped"),
            ("Disable HPET", self.disable_hpet, "HPET disabled"),
            ("Disable OneDrive", self.disable_onedrive, "OneDrive disabled")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def disable_telemetry(self):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\DataCollection") as key:
            winreg.SetValueEx(key, "AllowTelemetry", 0, winreg.REG_DWORD, 0)
        subprocess.run("sc config DiagTrack start= disabled", shell=True, check=True, timeout=10)
        subprocess.run("sc config dmwappushservice start= disabled", shell=True, check=True, timeout=10)
        return "Telemetry Disabled"

    async def disable_cortana(self):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\Windows Search") as key:
            winreg.SetValueEx(key, "AllowCortana", 0, winreg.REG_DWORD, 0)
        subprocess.run("taskkill /f /im SearchUI.exe", shell=True, capture_output=True)
        return "Cortana Disabled"

    async def disable_office_telemetry(self):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Policies\Microsoft\Office\16.0\osm") as key:
            winreg.SetValueEx(key, "EnableLogging", 0, winreg.REG_DWORD, 0)
        return "Office Telemetry Disabled"

    async def disable_copilot(self):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Policies\Microsoft\Windows\WindowsCopilot") as key:
            winreg.SetValueEx(key, "TurnOffWindowsCopilot", 0, winreg.REG_DWORD, 1)
        return "CoPilot Disabled"

    async def stop_updates(self):
        subprocess.run("net stop wuauserv", shell=True, check=True, timeout=10)
        subprocess.run("net stop bits", shell=True, check=True, timeout=10)
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU") as key:
            winreg.SetValueEx(key, "NoAutoUpdate", 0, winreg.REG_DWORD, 1)
        return "Updates Stopped"

    async def disable_hpet(self):
        subprocess.run("bcdedit /set useplatformclock no", shell=True, check=True, timeout=10)
        return "HPET Disabled"

    async def disable_onedrive(self):
        subprocess.run("taskkill /f /im OneDrive.exe", shell=True, capture_output=True)
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\OneDrive") as key:
            winreg.SetValueEx(key, "DisablePersonalSync", 0, winreg.REG_DWORD, 1)
        return "OneDrive Disabled"

    # Cleanup Tab
    def setup_cleanup_tab(self):
        frame = ttk.LabelFrame(self.tabs["Cleanup"], text="Cleanup Tools")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Clean System Drive", self.clean_system_drive, "System drive cleaned"),
            ("Remove Startup Programs", self.remove_startup_gui, "Startup items removed"),
            ("Uninstall UWP Apps", self.uninstall_uwp_gui, "UWP apps uninstalled"),
            ("Clean Browser Profiles", self.clean_browser_profiles, "Browser profiles cleaned"),
            ("Fix Registry Issues", self.fix_registry_issues, "Registry issues fixed"),
            ("Download Useful Apps", self.download_useful_apps, "Apps downloaded")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def clean_system_drive(self):
        temp_paths = [os.getenv("TEMP"), r"C:\Windows\Temp", r"C:\Windows\Prefetch", r"C:\$Recycle.Bin"]
        async with ThreadPoolExecutor() as executor:
            tasks = []
            for path in temp_paths:
                for item in glob.glob(f"{path}\*"):
                    if os.path.isfile(item):
                        tasks.append(self.loop.run_in_executor(executor, os.remove, item))
                    elif os.path.isdir(item):
                        tasks.append(self.loop.run_in_executor(executor, shutil.rmtree, item, True))
            await asyncio.gather(*tasks, return_exceptions=True)
        subprocess.run("cleanmgr /sagerun:1", shell=True, check=True, timeout=30)
        return "System Drive Cleaned"

    async def remove_startup_gui(self):
        startup_window = tk.Toplevel(self.root)
        startup_window.title("Remove Startup Programs")
        startup_window.geometry("800x600")
        ttk.Label(startup_window, text="Select Startup Items to Remove:").pack(pady=5)
        tree = ttk.Treeview(startup_window, columns=("Name", "Path"), show="headings")
        tree.heading("Name", text="Name")
        tree.heading("Path", text="Path")
        tree.pack(fill="both", expand=True)
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Run", 0, winreg.KEY_READ) as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                name, value, _ = winreg.EnumValue(key, i)
                tree.insert("", "end", values=(name, value))
        ttk.Button(startup_window, text="Remove Selected", 
                  command=lambda: self.run_in_thread(lambda: self.remove_startup([tree.item(item)["values"][0] for item in tree.selection()]))).pack(pady=5)

    async def remove_startup(self, app_names: List[str]):
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Run", 
                          0, winreg.KEY_SET_VALUE) as key:
            for name in app_names:
                winreg.DeleteValue(key, name)
        return f"Removed {', '.join(app_names)}"

    async def uninstall_uwp_gui(self):
        uwp_window = tk.Toplevel(self.root)
        uwp_window.title("Uninstall UWP Apps")
        uwp_window.geometry("800x600")
        ttk.Label(uwp_window, text="Select UWP Apps to Uninstall:").pack(pady=5)
        tree = ttk.Treeview(uwp_window, columns=("Name",), show="headings")
        tree.heading("Name", text="Name")
        tree.pack(fill="both", expand=True)
        result = subprocess.run("powershell -command \"Get-AppxPackage | Select-Object Name\"", shell=True, capture_output=True, text=True)
        for line in result.stdout.splitlines()[2:]:
            if line.strip():
                tree.insert("", "end", values=(line.strip(),))
        ttk.Button(uwp_window, text="Uninstall Selected", 
                  command=lambda: self.run_in_thread(lambda: self.uninstall_uwp([tree.item(item)["values"][0] for item in tree.selection()]))).pack(pady=5)

    async def uninstall_uwp(self, app_names: List[str]):
        async with ThreadPoolExecutor() as executor:
            tasks = [self.loop.run_in_executor(executor, lambda app=app: subprocess.run(
                f"powershell -command \"Get-AppxPackage *{app}* | Remove-AppxPackage\"", shell=True, check=True, timeout=20)) 
                for app in app_names]
            await asyncio.gather(*tasks)
        return f"Uninstalled {', '.join(app_names)}"

    async def clean_browser_profiles(self):
        browsers = {
            "Chrome": os.path.expanduser(r"~\AppData\Local\Google\Chrome\User Data\Default\Cache"),
            "Firefox": os.path.expanduser(r"~\AppData\Local\Mozilla\Firefox\Profiles\*.default-release\cache"),
            "Edge": os.path.expanduser(r"~\AppData\Local\Microsoft\Edge\User Data\Default\Cache")
        }
        async with ThreadPoolExecutor() as executor:
            tasks = []
            for path in browsers.values():
                for item in glob.glob(path + r"\*"):
                    if os.path.isfile(item):
                        tasks.append(self.loop.run_in_executor(executor, os.remove, item))
                    elif os.path.isdir(item):
                        tasks.append(self.loop.run_in_executor(executor, shutil.rmtree, item, True))
            await asyncio.gather(*tasks, return_exceptions=True)
        return "Browser Profiles Cleaned"

    async def fix_registry_issues(self):
        subprocess.run("sfc /scannow", shell=True, check=True, timeout=300)
        subprocess.run("DISM /Online /Cleanup-Image /RestoreHealth", shell=True, check=True, timeout=300)
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion", 0, winreg.KEY_SET_VALUE) as key:
            winreg.SetValueEx(key, "LastCleaned", 0, winreg.REG_SZ, datetime.now().isoformat())
        return "Registry Fixed"

    async def download_useful_apps(self):
        apps = {
            "notepad++": "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.2/npp.8.6.2.Installer.x64.exe",
            "7zip": "https://www.7-zip.org/a/7z2301-x64.exe"
        }
        async with aiohttp.ClientSession() as session:
            tasks = []
            for name, url in apps.items():
                async with session.get(url) as response:
                    if response.status == 200:
                        with open(os.path.join(self.backup_dir, f"{name}.exe"), "wb") as f:
                            f.write(await response.read())
                            tasks.append(f"Downloaded {name}")
            await asyncio.gather(*[asyncio.sleep(0.1) for _ in tasks])
        return "Apps Downloaded"

    # Hardware Tab
    def setup_hardware_tab(self):
        frame = ttk.LabelFrame(self.tabs["Hardware"], text="Hardware Management")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Inspect Hardware", self.inspect_hardware, "Hardware inspected"),
            ("Kill File Lock", self.kill_file_lock_gui, "File lock killed"),
            ("SSD/HDD Health Check", self.check_disk_health, "Disk health checked"),
            ("USB Device Control", self.usb_control_gui, "USB controlled"),
            ("Firmware Update Manager", self.firmware_update_manager, "Firmware checked"),
            ("Overclocking Assistant", self.overclocking_assistant_gui, "Overclocking assisted"),
            ("Stress Test Suite", self.stress_test_suite, "Stress test completed")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def inspect_hardware(self):
        c = wmi.WMI()
        cpu = f"CPU: {psutil.cpu_freq().current:.0f} MHz, {psutil.cpu_percent()}% Usage, Cores: {psutil.cpu_count()}"
        ram = f"RAM: {psutil.virtual_memory().total / (1024**3):.2f} GB Total, {psutil.virtual_memory().available / (1024**3):.2f} GB Free"
        disk = "\n".join([f"Disk {d.DeviceID}: {d.Size / (1024**3):.2f} GB Total, {psutil.disk_usage(d.DeviceID).free / (1024**3):.2f} GB Free" 
                         for d in c.Win32_LogicalDisk()])
        gpu = "\n".join([f"GPU: {g.Name}, VRAM: {g.AdapterRAM / (1024**3):.2f} GB" for g in c.Win32_VideoController()])
        report = f"{cpu}\n{ram}\n{disk}\n{gpu}"
        output_file = os.path.join(self.backup_dir, f"hardware_info_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Hardware Inspected"

    async def kill_file_lock_gui(self):
        lock_window = tk.Toplevel(self.root)
        lock_window.title("Kill File Lock")
        lock_window.geometry("600x400")
        ttk.Label(lock_window, text="Enter or select file path:").pack(pady=5)
        file_var = tk.StringVar()
        ttk.Entry(lock_window, textvariable=file_var).pack(pady=5, fill="x")
        ttk.Button(lock_window, text="Browse", command=lambda: file_var.set(filedialog.askopenfilename())).pack(pady=5)
        ttk.Button(lock_window, text="Unlock", 
                  command=lambda: self.run_in_thread(lambda: self.kill_file_lock(file_var.get()))).pack(pady=5)

    async def kill_file_lock(self, file_path: str):
        for proc in psutil.process_iter(['pid', 'name', 'open_files']):
            try:
                for file in proc.open_files():
                    if file_path.lower() in file.path.lower():
                        proc.kill()
                        await asyncio.sleep(0.1)  # Ensure process terminates
                        return f"Unlocked {file_path}"
            except psutil.NoSuchProcess:
                continue
        raise Exception(f"No process locking {file_path}")

    async def check_disk_health(self):
        c = wmi.WMI()
        health_info = ""
        for disk in c.Win32_DiskDrive():
            health_info += f"Disk: {disk.Caption}\nStatus: {disk.Status}\n"
            if hasattr(disk, "SMARTData"):
                health_info += "SMART: Available\n"
        output_file = os.path.join(self.backup_dir, f"disk_health_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(health_info)
        webbrowser.open(output_file)
        return "Disk Health Checked"

    async def usb_control_gui(self):
        usb_window = tk.Toplevel(self.root)
        usb_window.title("USB Device Control")
        usb_window.geometry("500x400")
        ttk.Label(usb_window, text="USB Control:").pack(pady=5)
        state_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(usb_window, text="Enable USB Ports", variable=state_var).pack(pady=5)
        ttk.Button(usb_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.control_usb(state_var.get()))).pack(pady=10)

    async def control_usb(self, enable: bool):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services\USBSTOR") as key:
            winreg.SetValueEx(key, "Start", 0, winreg.REG_DWORD, 3 if enable else 4)
        subprocess.run("pnputil /restart-device USBSTOR", shell=True, capture_output=True)
        return "USB Controlled"

    async def firmware_update_manager(self):
        c = wmi.WMI()
        bios = c.Win32_BIOS()[0]
        report = f"BIOS: {bios.SMBIOSBIOSVersion}\nManufacturer: {bios.Manufacturer}\n"
        # Simulation: Check for updates
        async with aiohttp.ClientSession() as session:
            async with session.get(f"https://example.com/firmware/check?version={bios.SMBIOSBIOSVersion}") as response:
                if response.status == 200:
                    report += "Update Status: Simulated check completed\n"
        output_file = os.path.join(self.backup_dir, f"firmware_info_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Firmware Checked"

    # Overclocking and Stress Test moved to Premium for consistency

    # Customization Tab
    def setup_customization_tab(self):
        frame = ttk.LabelFrame(self.tabs["Customization"], text="System Customization")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Edit HOSTS File", self.edit_hosts, "HOSTS file edited"),
            ("Add Desktop Menu Item", self.add_context_menu, "Context menu added"),
            ("Toggle Theme", self.toggle_theme_gui, "Theme toggled"),
            ("Customize Taskbar", self.customize_taskbar, "Taskbar customized"),
            ("Add Custom Run Command", self.add_run_command, "Run command added"),
            ("Desktop Icon Manager", self.desktop_icon_manager_gui, "Desktop icons managed"),
            ("Sound Scheme Editor", self.sound_scheme_editor_gui, "Sound scheme edited")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def edit_hosts(self):
        hosts_path = r"C:\Windows\System32\drivers\etc\hosts"
        if os.path.exists(hosts_path):
            subprocess.Popen(f"notepad.exe {hosts_path}")
            await asyncio.sleep(1)
            return "HOSTS Edited"
        raise Exception("HOSTS file not found")

    async def add_context_menu(self):
        with winreg.CreateKey(winreg.HKEY_CLASSES_ROOT, r"DesktopBackground\Shell\Optimizer") as key:
            with winreg.CreateKey(key, "command") as cmd_key:
                winreg.SetValue(cmd_key, "", winreg.REG_SZ, f'"{sys.executable}"')
        return "Context Menu Added"

    async def toggle_theme_gui(self):
        theme_window = tk.Toplevel(self.root)
        theme_window.title("Theme Switcher")
        theme_window.geometry("400x300")
        ttk.Label(theme_window, text="Select Theme:").pack(pady=5)
        theme_var = tk.StringVar(value=self.get_setting("theme", "light"))
        themes = ["light", "dark", "system"]
        for theme in themes:
            ttk.Radiobutton(theme_window, text=theme.capitalize(), variable=theme_var, value=theme).pack(pady=2)
        ttk.Button(theme_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.toggle_theme(theme_var.get()))).pack(pady=10)

    async def toggle_theme(self, theme: str):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize") as key:
            winreg.SetValueEx(key, "AppsUseLightTheme", 0, winreg.REG_DWORD, 1 if theme in ["light", "system"] else 0)
            winreg.SetValueEx(key, "SystemUsesLightTheme", 0, winreg.REG_DWORD, 1 if theme in ["light", "system"] else 0)
        self.save_setting("theme", theme)
        return "Theme Toggled"

    async def customize_taskbar(self):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") as key:
            winreg.SetValueEx(key, "TaskbarSmallIcons", 0, winreg.REG_DWORD, 1)
            winreg.SetValueEx(key, "ShowTaskViewButton", 0, winreg.REG_DWORD, 0)
            winreg.SetValueEx(key, "ShowCortanaButton", 0, winreg.REG_DWORD, 0)
        return "Taskbar Customized"

    async def add_run_command(self):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\opti.exe") as key:
            winreg.SetValueEx(key, "", 0, winreg.REG_SZ, sys.executable)
        return "Run Command 'opti' Added"

    async def desktop_icon_manager_gui(self):
        icon_window = tk.Toplevel(self.root)
        icon_window.title("Desktop Icon Manager")
        icon_window.geometry("500x400")
        ttk.Label(icon_window, text="Manage Desktop Icons:").pack(pady=5)
        icons = {
            "This PC": "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}",
            "Recycle Bin": "::{645FF040-5081-101B-9F08-00AA002F954E}",
            "Network": "::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
        }
        icon_vars = {name: tk.BooleanVar(value=True) for name in icons}
        for name, var in icon_vars.items():
            ttk.Checkbutton(icon_window, text=name, variable=var).pack(pady=2)
        ttk.Button(icon_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.manage_desktop_icons({n: v.get() for n, v in icon_vars.items()}))).pack(pady=10)

    async def manage_desktop_icons(self, icons: Dict[str, bool]):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace") as key:
            existing = {winreg.EnumKey(key, i) for i in range(winreg.QueryInfoKey(key)[0])}
            for name, enabled in icons.items():
                clsid = icons[name]
                if enabled and clsid not in existing:
                    winreg.CreateKey(key, clsid)
                elif not enabled and clsid in existing:
                    winreg.DeleteKey(key, clsid)
        return "Icons Managed"

    async def sound_scheme_editor_gui(self):
        sound_window = tk.Toplevel(self.root)
        sound_window.title("Sound Scheme Editor")
        sound_window.geometry("600x400")
        ttk.Label(sound_window, text="Edit System Sounds:").pack(pady=5)
        event_var = tk.StringVar(value="Windows Exit")
        sound_var = tk.StringVar()
        events = ["Windows Exit", "System Notification", "Critical Stop"]
        ttk.Combobox(sound_window, textvariable=event_var, values=events).pack(pady=5)
        ttk.Entry(sound_window, textvariable=sound_var).pack(pady=5, fill="x")
        ttk.Button(sound_window, text="Browse", command=lambda: sound_var.set(filedialog.askopenfilename(filetypes=[("WAV Files", "*.wav")]))).pack(pady=5)
        ttk.Button(sound_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.set_sound_scheme(event_var.get(), sound_var.get()))).pack(pady=5)

    async def set_sound_scheme(self, event: str, sound_file: str):
        event_keys = {
            "Windows Exit": r"AppEvents\Schemes\Apps\.Default\Windows Exit\.Current",
            "System Notification": r"AppEvents\Schemes\Apps\.Default\SystemNotification\.Current",
            "Critical Stop": r"AppEvents\Schemes\Apps\.Default\Critical Stop\.Current"
        }
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, event_keys[event]) as key:
            winreg.SetValueEx(key, "", 0, winreg.REG_SZ, sound_file)
        return "Sound Scheme Edited"

    # Security Tab
    def setup_security_tab(self):
        frame = ttk.LabelFrame(self.tabs["Security"], text="Security & Privacy")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Block Ads/Trackers", self.block_ads_trackers, "Ads and trackers blocked"),
            ("Manage Firewall", self.manage_firewall_gui, "Firewall rules updated"),
            ("Remove OEM Bloatware", self.remove_bloatware, "Bloatware removed"),
            ("Real-Time Threat Detection", self.start_threat_detection, "Threat detection started"),
            ("Privacy Audit", self.privacy_audit, "Privacy audit completed"),
            ("Encrypted Backup", self.encrypted_backup, "Backup encrypted")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def block_ads_trackers(self):
        async with aiohttp.ClientSession() as session:
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            async with session.get(url, timeout=aiohttp.ClientTimeout(total=15)) as response:
                if response.status == 200:
                    with open(r"C:\Windows\System32\drivers\etc\hosts", "a") as f:
                        f.write(await response.text())
                    await self.flush_dns()
                    return "Ads Blocked"
                raise Exception(f"Failed to fetch hosts file: {response.status}")

    async def manage_firewall_gui(self):
        fw_window = tk.Toplevel(self.root)
        fw_window.title("Firewall Manager")
        fw_window.geometry("800x600")
        ttk.Label(fw_window, text="Firewall Rules:").pack(pady=5)
        tree = ttk.Treeview(fw_window, columns=("Name", "Port", "Action"), show="headings")
        tree.heading("Name", text="Rule Name")
        tree.heading("Port", text="Port")
        tree.heading("Action", text="Action")
        tree.pack(fill="both", expand=True)
        ttk.Label(fw_window, text="New Rule:").pack(pady=5)
        name_var = tk.StringVar()
        port_var = tk.StringVar()
        action_var = tk.StringVar(value="block")
        ttk.Entry(fw_window, textvariable=name_var).pack(pady=2)
        ttk.Entry(fw_window, textvariable=port_var).pack(pady=2)
        ttk.Radiobutton(fw_window, text="Block", variable=action_var, value="block").pack(pady=2)
        ttk.Radiobutton(fw_window, text="Allow", variable=action_var, value="allow").pack(pady=2)
        ttk.Button(fw_window, text="Add Rule", 
                  command=lambda: self.run_in_thread(lambda: self.add_firewall_rule(name_var.get(), port_var.get(), action_var.get()))).pack(pady=5)

    async def add_firewall_rule(self, name: str, port: str, action: str):
        subprocess.run(f"netsh advfirewall firewall add rule name='{name}' dir=in action={action} protocol=TCP localport={port}", 
                      shell=True, check=True, timeout=10)
        return f"Rule '{name}' Added"

    async def remove_bloatware(self):
        bloatware = ["*Dell*", "*HP*", "*Lenovo*", "*CandyCrush*", "*Xbox*", "*McAfee*", "*Norton*"]
        async with ThreadPoolExecutor() as executor:
            tasks = [self.loop.run_in_executor(executor, lambda app=app: subprocess.run(
                f"powershell -command \"Get-AppxPackage {app} | Remove-AppxPackage\"", shell=True, capture_output=True, timeout=20)) 
                for app in bloatware]
            await asyncio.gather(*tasks, return_exceptions=True)
        return "Bloatware Removed"

    async def start_threat_detection(self):
        async def monitor():
            while self.running:
                for proc in psutil.process_iter(['pid', 'name', 'exe', 'cmdline']):
                    try:
                        if any(sus in proc.name().lower() for sus in ["malware", "virus", "trojan", "hack"]):
                            proc.kill()
                            logging.warning(f"Suspicious process {proc.name()} terminated")
                            messagebox.showwarning("Threat Detected", f"Terminated: {proc.name()}")
                    except psutil.NoSuchProcess:
                        continue
                await asyncio.sleep(5)
        self.loop.create_task(monitor())
        return "Threat Detection Started"

    async def privacy_audit(self):
        issues = []
        if self.get_setting("telemetry", "enabled") == "enabled":
            issues.append("Telemetry is enabled")
        if os.path.exists(r"C:\Program Files (x86)\McAfee") or os.path.exists(r"C:\Program Files\McAfee"):
            issues.append("McAfee bloatware detected")
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\DataCollection", 0, winreg.KEY_READ) as key:
            try:
                if winreg.QueryValueEx(key, "AllowTelemetry")[0] != 0:
                    issues.append("Telemetry policy not fully disabled")
            except FileNotFoundError:
                pass
        report = "Privacy Audit:\n" + "\n".join(issues) if issues else "No privacy issues detected"
        output_file = os.path.join(self.backup_dir, f"privacy_audit_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Audit Completed"

    async def encrypted_backup(self):
        backup_file = os.path.join(self.backup_dir, f"registry_{datetime.now().strftime('%Y%m%d_%H%M%S')}.reg")
        subprocess.run(f"reg export HKLM \"{backup_file}\" /y", shell=True, check=True, timeout=60)
        with open(backup_file, "rb") as f:
            encrypted = CIPHER.encrypt(f.read())
        enc_file = f"{backup_file}.enc"
        with open(enc_file, "wb") as f:
            f.write(encrypted)
        os.remove(backup_file)
        return "Backup Encrypted"

    # Automation Tab
    def setup_automation_tab(self):
        frame = ttk.LabelFrame(self.tabs["Automation"], text="Automation Tools")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Schedule Tasks", self.schedule_tasks_gui, "Tasks scheduled"),
            ("Run Custom Script", self.run_custom_script_gui, "Script executed"),
            ("Silent Optimization", self.run_silent_optimization, "Silent optimization completed"),
            ("Reset to Defaults", self.reset_to_defaults, "Settings reset to defaults"),
            ("Automatic Registry Backup", self.automatic_registry_backup, "Registry backed up")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def schedule_tasks_gui(self):
        sched_window = tk.Toplevel(self.root)
        sched_window.title("Schedule Tasks")
        sched_window.geometry("800x600")
        ttk.Label(sched_window, text="Schedule a Task:").pack(pady=5)
        task_var = tk.StringVar(value="Flush DNS")
        interval_var = tk.IntVar(value=60)
        tasks = ["Flush DNS", "Clean System Drive", "Disable Telemetry", "Network Speed Test", "Privacy Audit"]
        ttk.Combobox(sched_window, textvariable=task_var, values=tasks).pack(pady=5)
        ttk.Label(sched_window, text="Interval (minutes):").pack(pady=5)
        ttk.Entry(sched_window, textvariable=interval_var).pack(pady=5)
        ttk.Button(sched_window, text="Add Schedule", 
                  command=lambda: self.run_in_thread(lambda: self.schedule_task(task_var.get(), interval_var.get()))).pack(pady=10)

        ttk.Label(sched_window, text="Current Schedules:").pack(pady=5)
        tree = ttk.Treeview(sched_window, columns=("Task", "Interval", "Last Run"), show="headings")
        tree.heading("Task", text="Task")
        tree.heading("Interval", text="Interval (min)")
        tree.heading("Last Run", text="Last Run")
        tree.pack(fill="both", expand=True)
        c = self.db_conn.cursor()
        c.execute("SELECT task, interval, last_run FROM schedules")
        for row in c.fetchall():
            tree.insert("", "end", values=(row[0], row[1], datetime.fromtimestamp(row[2]).strftime('%Y-%m-%d %H:%M:%S') if row[2] else "Never"))

    async def schedule_task(self, task: str, interval: int):
        c = self.db_conn.cursor()
        c.execute("INSERT INTO schedules (task, interval, last_run) VALUES (?, ?, 0)", (task, interval))
        self.db_conn.commit()
        return f"Scheduled {task}"

    async def run_custom_script_gui(self):
        script_window = tk.Toplevel(self.root)
        script_window.title("Run Custom Script")
        script_window.geometry("800x600")
        ttk.Label(script_window, text="Select Script File (.ps1 or .bat):").pack(pady=5)
        script_var = tk.StringVar()
        ttk.Entry(script_window, textvariable=script_var).pack(pady=5, fill="x")
        ttk.Button(script_window, text="Browse", command=lambda: script_var.set(filedialog.askopenfilename(filetypes=[("Script Files", "*.ps1 *.bat")]))).pack(pady=5)
        output_text = tk.Text(script_window, height=20)
        output_text.pack(pady=5, fill="both", expand=True)
        ttk.Button(script_window, text="Run", 
                  command=lambda: self.run_in_thread(lambda: self.run_custom_script(script_var.get(), output_text))).pack(pady=5)

    async def run_custom_script(self, script_path: str, output_widget: tk.Text):
        if script_path.endswith(".ps1"):
            result = subprocess.run(f"powershell -ExecutionPolicy Bypass -File \"{script_path}\"", shell=True, capture_output=True, text=True, timeout=60)
        elif script_path.endswith(".bat"):
            result = subprocess.run(f"cmd /c \"{script_path}\"", shell=True, capture_output=True, text=True, timeout=60)
        else:
            raise Exception("Unsupported script type")
        output_widget.delete(1.0, tk.END)
        output_widget.insert(tk.END, result.stdout + result.stderr)
        return f"Executed {script_path}"

    async def run_silent_optimization(self):
        await asyncio.gather(
            self.optimize_system(),
            self.flush_dns(),
            self.clean_system_drive(),
            self.disable_telemetry(),
            self.optimize_boot_time()
        )
        return "Silent Optimization Completed"

    async def reset_to_defaults(self):
        try:
            self.db_conn.close()
            os.remove(DB_FILE)
            os.remove(self.config_file) if os.path.exists(self.config_file) else None
            shutil.rmtree(self.backup_dir, ignore_errors=True)
            os.makedirs(self.backup_dir)
            self.db_conn = init_db()
            return "Reset to Defaults"
        except Exception as e:
            logging.error(f"Reset failed: {e}")
            raise

    async def automatic_registry_backup(self):
        await self.encrypted_backup()
        return "Registry Backed Up"

    # Premium Tab
    def setup_premium_tab(self):
        frame = ttk.LabelFrame(self.tabs["Premium"], text="Premium Features")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("AI-Driven Optimization", self.ai_optimization, "AI optimization completed"),
            ("Benchmark System", self.benchmark_system, "Benchmark completed"),
            ("Encrypted Backup to Cloud", self.encrypted_backup_to_cloud, "Backup uploaded"),
            ("Network Traffic Analyzer", self.network_traffic_analyzer, "Traffic analyzed"),
            ("Overclocking Assistant", self.overclocking_assistant_gui, "Overclocking assisted"),
            ("One-Click Optimization", self.one_click_optimization, "Full optimization completed"),
            ("Stress Test Suite", self.stress_test_suite, "Stress test completed"),
            ("Integrated Premium VPN", self.premium_vpn_gui, "VPN connected"),
            ("Custom Boot Loader", self.custom_boot_loader, "Boot loader customized"),
            ("Script Marketplace", self.script_marketplace_gui, "Marketplace accessed"),
            ("Predictive Maintenance", self.predictive_maintenance, "Maintenance predicted"),
            ("SHODAN Advanced Reports", self.shodan_advanced_reports, "SHODAN report generated"),
            ("Remote System Management", self.remote_management_gui, "Remote management started"),
            ("Mobile Companion Simulation", self.mobile_companion_simulation, "Mobile companion simulated")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def ai_optimization(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        cpu_usage = psutil.cpu_percent(interval=1)
        ram_usage = psutil.virtual_memory().percent
        disk_usage = psutil.disk_usage('/').percent
        tweaks = []
        if cpu_usage > 80:
            tweaks.append("Lowering process priorities")
            for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
                if proc.cpu_percent() > 20:
                    proc.nice(psutil.IDLE_PRIORITY_CLASS)
        if ram_usage > 90:
            tweaks.append("Optimizing memory")
            await self.optimize_system()
        if disk_usage > 90:
            tweaks.append("Cleaning disk")
            await self.clean_system_drive()
        report = f"AI Optimization:\nCPU: {cpu_usage}%\nRAM: {ram_usage}%\nDisk: {disk_usage}%\nTweaks: {', '.join(tweaks) if tweaks else 'None required'}"
        with open(os.path.join(self.backup_dir, f"ai_optimization_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"), "w") as f:
            f.write(report)
        return "AI Optimization Done"

    async def benchmark_system(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        start = time.time()
        with ProcessPoolExecutor() as executor:
            await self.loop.run_in_executor(executor, lambda: [hashlib.sha256(str(x).encode()).hexdigest() for x in range(5000000)])
        cpu_time = time.time() - start
        start = time.time()
        with open("benchmark.tmp", "wb") as f:
            f.write(os.urandom(1024*1024*100))  # 100MB
        disk_time = time.time() - start
        os.remove("benchmark.tmp")
        result = f"CPU Benchmark: {5000 / cpu_time:.2f} ops/s\nDisk Write: {100 / disk_time:.2f} MB/s"
        output_file = os.path.join(self.backup_dir, f"benchmark_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(result)
        webbrowser.open(output_file)
        return "Benchmark Completed"

    async def encrypted_backup_to_cloud(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        backup_file = os.path.join(self.backup_dir, f"registry_{datetime.now().strftime('%Y%m%d_%H%M%S')}.reg")
        subprocess.run(f"reg export HKLM \"{backup_file}\" /y", shell=True, check=True, timeout=60)
        with open(backup_file, "rb") as f:
            encrypted = CIPHER.encrypt(f.read())
        enc_file = f"{backup_file}.enc"
        with open(enc_file, "wb") as f:
            f.write(encrypted)
        # Simulation: Cloud upload
        async with aiohttp.ClientSession() as session:
            with open(enc_file, "rb") as f:
                async with session.post("https://example.com/upload", data={"file": f}) as resp:
                    if resp.status != 200:
                        raise Exception(f"Cloud upload failed: {resp.status}")
        os.remove(backup_file)
        os.remove(enc_file)
        return "Backup Uploaded"

    async def network_traffic_analyzer(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        traffic = {}
        for proc in psutil.process_iter(['pid', 'name', 'net_io_counters']):
            try:
                net = proc.net_io_counters()
                traffic[proc.name()] = (net.bytes_sent / 1024, net.bytes_recv / 1024)
            except:
                pass
        report = "\n".join(f"{name}: Sent {sent:.2f} KB, Received {recv:.2f} KB" for name, (sent, recv) in traffic.items())
        output_file = os.path.join(self.backup_dir, f"traffic_analysis_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Traffic Analyzed"

    async def overclocking_assistant_gui(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        oc_window = tk.Toplevel(self.root)
        oc_window.title("Overclocking Assistant")
        oc_window.geometry("600x500")
        ttk.Label(oc_window, text="WARNING: Overclocking may damage hardware!").pack(pady=5)
        ttk.Label(oc_window, text="CPU Multiplier Increase (%):").pack(pady=5)
        multi_var = tk.DoubleVar(value=5.0)
        ttk.Entry(oc_window, textvariable=multi_var).pack(pady=5)
        ttk.Label(oc_window, text="Note: Simulation only; real overclocking requires BIOS access").pack(pady=5)
        ttk.Button(oc_window, text="Apply Simulation", 
                  command=lambda: self.run_in_thread(lambda: self.overclock_cpu(multi_var.get()))).pack(pady=10)

    async def overclock_cpu(self, increase_percent: float):
        messagebox.showinfo("Simulation", f"Simulated CPU overclock by {increase_percent}%")
        return "Overclock Simulated"

    async def one_click_optimization(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        await asyncio.gather(
            self.optimize_system(),
            self.flush_dns(),
            self.clean_system_drive(),
            self.disable_telemetry(),
            self.optimize_boot_time(),
            self.block_ads_trackers(),
            self.fix_registry_issues()
        )
        return "One-Click Optimization Done"

    async def stress_test_suite(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        start = time.time()
        with ProcessPoolExecutor() as executor:
            await self.loop.run_in_executor(executor, lambda: [hashlib.sha256(str(x).encode()).hexdigest() for x in range(10000000)])
        cpu_time = time.time() - start
        start = time.time()
        with open("stress_test.tmp", "wb") as f:
            f.write(os.urandom(1024*1024*200))  # 200MB
        disk_time = time.time() - start
        ram_usage = psutil.virtual_memory().percent
        os.remove("stress_test.tmp")
        result = f"CPU Stress: {10000 / cpu_time:.2f} ops/s\nDisk Write: {200 / disk_time:.2f} MB/s\nRAM Usage: {ram_usage}%"
        output_file = os.path.join(self.backup_dir, f"stress_test_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(result)
        webbrowser.open(output_file)
        return "Stress Test Completed"

    async def premium_vpn_gui(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        vpn_window = tk.Toplevel(self.root)
        vpn_window.title("Premium VPN")
        vpn_window.geometry("500x400")
        ttk.Label(vpn_window, text="Premium VPN Configuration:").pack(pady=5)
        server_var = tk.StringVar(value="premium.vpn.server")
        username_var = tk.StringVar()
        password_var = tk.StringVar()
        ttk.Entry(vpn_window, textvariable=server_var).pack(pady=5)
        ttk.Entry(vpn_window, textvariable=username_var).pack(pady=5)
        ttk.Entry(vpn_window, textvariable=password_var, show="*").pack(pady=5)
        ttk.Button(vpn_window, text="Connect (Simulation)", 
                  command=lambda: self.run_in_thread(lambda: self.premium_vpn_connect(server_var.get(), username_var.get(), password_var.get()))).pack(pady=10)

    async def premium_vpn_connect(self, server: str, username: str, password: str):
        # Simulation
        messagebox.showinfo("VPN", f"Simulated Premium VPN connection to {server}")
        return "VPN Connected"

    async def custom_boot_loader(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        subprocess.run("bcdedit /set {current} description \"Optimizer Pro Boot\"", shell=True, check=True, timeout=10)
        subprocess.run("bcdedit /set {current} bootstatuspolicy ignoreallfailures", shell=True, check=True, timeout=10)
        return "Boot Loader Customized"

    async def script_marketplace_gui(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        market_window = tk.Toplevel(self.root)
        market_window.title("Script Marketplace")
        market_window.geometry("800x600")
        ttk.Label(market_window, text="Script Marketplace:").pack(pady=5)
        scripts = {
            "Cleanup Script": "cleanup.ps1",
            "Network Boost": "network_boost.ps1",
            "Performance Tune": "performance_tune.ps1"
        }
        tree = ttk.Treeview(market_window, columns=("Name", "File", "Description"), show="headings")
        tree.heading("Name", text="Script Name")
        tree.heading("File", text="File")
        tree.heading("Description", text="Description")
        tree.pack(fill="both", expand=True)
        for name, file in scripts.items():
            tree.insert("", "end", values=(name, file, f"Simulated {name} script"))
        ttk.Button(market_window, text="Download", 
                  command=lambda: self.run_in_thread(lambda: self.download_script(tree.item(tree.selection())["values"][1]))).pack(pady=5)

    async def download_script(self, script_file: str):
        with open(os.path.join(self.backup_dir, script_file), "w") as f:
            f.write("# Simulated script content from Optimizer Pro Marketplace")
        webbrowser.open(os.path.join(self.backup_dir, script_file))
        return f"Downloaded {script_file}"

    async def predictive_maintenance(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        cpu_temp = psutil.sensors_temperatures().get("coretemp", [None])[0].current if psutil.sensors_temperatures() else 0
        disk_usage = psutil.disk_usage('/').percent
        warnings = []
        if cpu_temp > 80:
            warnings.append("High CPU temperature detected! Consider cooling solutions.")
        if disk_usage > 95:
            warnings.append("Disk nearly full! Clean up space soon.")
        report = f"Predictive Maintenance:\nCPU Temp: {cpu_temp}°C\nDisk Usage: {disk_usage}%\nWarnings: {', '.join(warnings) if warnings else 'None'}"
        output_file = os.path.join(self.backup_dir, f"maintenance_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Maintenance Predicted"

    async def shodan_advanced_reports(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        async with aiohttp.ClientSession() as session:
            ip = socket.gethostbyname(socket.gethostname())
            url = f"https://api.shodan.io/shodan/host/{ip}?key={self.shodan_api_key}"
            async with session.get(url, timeout=aiohttp.ClientTimeout(total=15)) as response:
                if response.status == 200:
                    data = await response.json()
                    report = json.dumps(data, indent=4)
                    output_file = os.path.join(self.backup_dir, f"shodan_report_{ip}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json")
                    with open(output_file, "w") as f:
                        f.write(report)
                    webbrowser.open(output_file)
                    return "SHODAN Report Generated"
                                raise Exception(f"SHODAN API failed: {response.status}")
    
    async def remote_management_gui(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        remote_window = tk.Toplevel(self.root)
        remote_window.title("Remote System Management")
        remote_window.geometry("600x400")
        ttk.Label(remote_window, text="Remote PC IP Address:").pack(pady=5)
        ip_var = tk.StringVar()
        ttk.Entry(remote_window, textvariable=ip_var).pack(pady=5)
        ttk.Label(remote_window, text="Command to Execute:").pack(pady=5)
        cmd_var = tk.StringVar(value="Optimize System")
        commands = ["Optimize System", "Flush DNS", "Clean System Drive"]
        ttk.Combobox(remote_window, textvariable=cmd_var, values=commands).pack(pady=5)
        ttk.Button(remote_window, text="Execute (Simulation)", 
                  command=lambda: self.run_in_thread(lambda: self.remote_management(ip_var.get(), cmd_var.get()))).pack(pady=10)

    async def remote_management(self, ip: str, command: str):
        # Simulation: Real remote management would require network protocol
        func_map = {
            "Optimize System": self.optimize_system,
            "Flush DNS": self.flush_dns,
            "Clean System Drive": self.clean_system_drive
        }
        if command in func_map:
            await func_map[command]()
            messagebox.showinfo("Remote Management", f"Simulated execution of '{command}' on {ip}")
            return f"Remote {command} Executed on {ip}"
        raise Exception(f"Unsupported command: {command}")

    async def mobile_companion_simulation(self):
        if not self.is_premium():
            raise Exception("Premium feature requires license")
        mobile_window = tk.Toplevel(self.root)
        mobile_window.title("Mobile Companion Simulation")
        mobile_window.geometry("400x600")
        ttk.Label(mobile_window, text="Mobile Companion (Simulation):").pack(pady=5)
        ttk.Button(mobile_window, text="Check System Status", 
                  command=lambda: self.run_in_thread(self.check_system_status)).pack(pady=5)
        ttk.Button(mobile_window, text="Run Optimization", 
                  command=lambda: self.run_in_thread(self.one_click_optimization)).pack(pady=5)
        status_text = tk.Text(mobile_window, height=20)
        status_text.pack(pady=5, fill="both", expand=True)
        self.mobile_status_widget = status_text
        return "Mobile Companion Simulated"

    async def check_system_status(self):
        status = f"CPU: {psutil.cpu_percent()}%\nRAM: {psutil.virtual_memory().percent}%\nDisk: {psutil.disk_usage('/').percent}%"
        self.mobile_status_widget.delete(1.0, tk.END)
        self.mobile_status_widget.insert(tk.END, status)
        return "System Status Checked"

    # Advanced Tab
    def setup_advanced_tab(self):
        frame = ttk.LabelFrame(self.tabs["Advanced"], text="Cutting-Edge Features")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        buttons = [
            ("Context-Aware Profiles", self.context_aware_profiles_gui, "Profile applied"),
            ("Behavior-Based Telemetry Block", self.behavior_telemetry_block, "Telemetry blocked"),
            ("Smart Startup Manager", self.smart_startup_manager, "Startup managed"),
            ("System Snapshot Simulator", self.system_snapshot_simulator, "Snapshot simulated"),
            ("Crash Recovery Tool", self.crash_recovery_tool, "Recovery prepared"),
            ("A/B Testing for Tweaks", self.ab_testing_gui, "A/B test completed"),
            ("Retro Mode", self.retro_mode, "Retro mode applied"),
            ("Sound Scheme Editor", self.sound_scheme_editor_gui, "Sound scheme edited"),
            ("Kernel-Level Tweaks", self.kernel_tweaks, "Kernel tweaked"),
            ("Service Dependency Viewer", self.service_dependency_viewer, "Dependencies viewed"),
            ("IoT Device Management", self.iot_device_management_gui, "IoT devices managed"),
            ("AI Voice Assistant Simulation", self.ai_voice_assistant_simulation, "Voice assistant simulated"),
            ("Blockchain Privacy Simulation", self.blockchain_privacy_simulation, "Privacy enhanced")
        ]
        for text, cmd, msg in buttons:
            ttk.Button(frame, text=text, command=lambda c=cmd, m=msg: self.run_in_thread(c, success_msg=m)).pack(pady=3, fill="x")

    async def context_aware_profiles_gui(self):
        profile_window = tk.Toplevel(self.root)
        profile_window.title("Context-Aware Profiles")
        profile_window.geometry("500x400")
        ttk.Label(profile_window, text="Select Profile:").pack(pady=5)
        profile_var = tk.StringVar(value="Gaming")
        profiles = ["Gaming", "Work", "Power Saving", "Custom"]
        ttk.Combobox(profile_window, textvariable=profile_var, values=profiles).pack(pady=5)
        ttk.Button(profile_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.set_context_profile(profile_var.get()))).pack(pady=10)

    async def set_context_profile(self, profile: str):
        profiles = {
            "Gaming": [self.optimize_system, self.disable_telemetry, self.customize_power_plan_gui],
            "Work": [self.customize_power_plan_gui, self.clean_system_drive],
            "Power Saving": [lambda: subprocess.run("powercfg -setactive SCHEME_MAX", shell=True, check=True)],
            "Custom": [self.optimize_system]  # Placeholder
        }
        if profile in profiles:
            await asyncio.gather(*[f() for f in profiles[profile]])
            self.save_setting("current_profile", profile)
            return f"Profile {profile} Set"
        raise Exception(f"Unknown profile: {profile}")

    async def behavior_telemetry_block(self):
        async def monitor_telemetry():
            while self.running:
                for proc in psutil.process_iter(['pid', 'name', 'connections', 'exe']):
                    try:
                        if "telemetry" in proc.name().lower() and proc.connections():
                            proc.kill()
                            logging.warning(f"Telemetry process {proc.name()} blocked")
                            messagebox.showinfo("Telemetry Blocked", f"Blocked: {proc.name()}")
                    except psutil.NoSuchProcess:
                        continue
                await asyncio.sleep(10)
        self.loop.create_task(monitor_telemetry())
        return "Behavior-Based Telemetry Blocked"

    async def smart_startup_manager(self):
        startup_items = {}
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Run", 0, winreg.KEY_READ) as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                name, value, _ = winreg.EnumValue(key, i)
                usage = "High" if "update" in name.lower() else "Low"  # Simplified heuristic
                startup_items[name] = {"path": value, "usage": usage}
        report = "\n".join(f"{name}: {item['path']} (Usage: {item['usage']}, Suggested: {'Remove' if item['usage'] == 'High' else 'Keep'})" 
                          for name, item in startup_items.items())
        output_file = os.path.join(self.backup_dir, f"startup_suggestion_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Startup Managed"

    async def system_snapshot_simulator(self):
        snapshot = {
            "cpu_usage": psutil.cpu_percent(interval=1),
            "ram_usage": psutil.virtual_memory().percent,
            "disk_usage": psutil.disk_usage('/').percent,
            "running_processes": [proc.name() for proc in psutil.process_iter(['name'])]
        }
        output_file = os.path.join(self.backup_dir, f"system_snapshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json")
        with open(output_file, "w") as f:
            json.dump(snapshot, f, indent=4)
        webbrowser.open(output_file)
        return "Snapshot Simulated"

    async def crash_recovery_tool(self):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce") as key:
            winreg.SetValueEx(key, "OptimizerRecovery", 0, winreg.REG_SZ, f'"{sys.executable}" --recover')
        backup_file = os.path.join(self.backup_dir, f"recovery_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.reg")
        subprocess.run(f"reg export HKLM \"{backup_file}\" /y", shell=True, check=True, timeout=60)
        return "Recovery Prepared"

    async def ab_testing_gui(self):
        ab_window = tk.Toplevel(self.root)
        ab_window.title("A/B Testing for Tweaks")
        ab_window.geometry("600x500")
        ttk.Label(ab_window, text="Select Tweaks to Compare:").pack(pady=5)
        tweak_a_var = tk.StringVar(value="Optimize System")
        tweak_b_var = tk.StringVar(value="Disable Telemetry")
        tweaks = ["Optimize System", "Disable Telemetry", "Clean System Drive", "Flush DNS"]
        ttk.Label(ab_window, text="Tweak A:").pack(pady=2)
        ttk.Combobox(ab_window, textvariable=tweak_a_var, values=tweaks).pack(pady=2)
        ttk.Label(ab_window, text="Tweak B:").pack(pady=2)
        ttk.Combobox(ab_window, textvariable=tweak_b_var, values=tweaks).pack(pady=2)
        ttk.Button(ab_window, text="Run Test", 
                  command=lambda: self.run_in_thread(lambda: self.ab_testing(tweak_a_var.get(), tweak_b_var.get()))).pack(pady=10)

    async def ab_testing(self, tweak_a: str, tweak_b: str):
        func_map = {
            "Optimize System": self.optimize_system,
            "Disable Telemetry": self.disable_telemetry,
            "Clean System Drive": self.clean_system_drive,
            "Flush DNS": self.flush_dns
        }
        start_a = time.time()
        await func_map[tweak_a]()
        time_a = time.time() - start_a
        start_b = time.time()
        await func_map[tweak_b]()
        time_b = time.time() - start_b
        report = f"A/B Testing Results:\nTweak A ({tweak_a}): {time_a:.2f}s\nTweak B ({tweak_b}): {time_b:.2f}s"
        output_file = os.path.join(self.backup_dir, f"ab_test_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "A/B Test Completed"

    async def retro_mode(self):
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Control Panel\Desktop") as key:
            winreg.SetValueEx(key, "Wallpaper", 0, winreg.REG_SZ, r"C:\Windows\Web\Wallpaper\Windows\img0.jpg")
            winreg.SetValueEx(key, "TileWallpaper", 0, winreg.REG_SZ, "0")
            winreg.SetValueEx(key, "WallpaperStyle", 0, winreg.REG_SZ, "2")
        messagebox.showinfo("Retro Mode", "Retro Windows 98 style applied (wallpaper only)")
        return "Retro Mode Applied"

    async def sound_scheme_editor_gui(self):
        sound_window = tk.Toplevel(self.root)
        sound_window.title("Sound Scheme Editor")
        sound_window.geometry("600x400")
        ttk.Label(sound_window, text="Edit System Sounds:").pack(pady=5)
        event_var = tk.StringVar(value="Windows Exit")
        sound_var = tk.StringVar()
        events = ["Windows Exit", "System Notification", "Critical Stop"]
        ttk.Combobox(sound_window, textvariable=event_var, values=events).pack(pady=5)
        ttk.Entry(sound_window, textvariable=sound_var).pack(pady=5, fill="x")
        ttk.Button(sound_window, text="Browse", command=lambda: sound_var.set(filedialog.askopenfilename(filetypes=[("WAV Files", "*.wav")]))).pack(pady=5)
        ttk.Button(sound_window, text="Apply", 
                  command=lambda: self.run_in_thread(lambda: self.set_sound_scheme(event_var.get(), sound_var.get()))).pack(pady=5)

    async def set_sound_scheme(self, event: str, sound_file: str):
        event_keys = {
            "Windows Exit": r"AppEvents\Schemes\Apps\.Default\Windows Exit\.Current",
            "System Notification": r"AppEvents\Schemes\Apps\.Default\SystemNotification\.Current",
            "Critical Stop": r"AppEvents\Schemes\Apps\.Default\Critical Stop\.Current"
        }
        if not os.path.exists(sound_file):
            raise Exception("Sound file not found")
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, event_keys[event]) as key:
            winreg.SetValueEx(key, "", 0, winreg.REG_SZ, sound_file)
        return "Sound Scheme Edited"

    async def kernel_tweaks(self):
        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management") as key:
            winreg.SetValueEx(key, "LargeSystemCache", 0, winreg.REG_DWORD, 1)
            winreg.SetValueEx(key, "DisablePagingExecutive", 0, winreg.REG_DWORD, 1)
        subprocess.run("bcdedit /set disabledynamictick yes", shell=True, check=True, timeout=10)
        return "Kernel Tweaked"

    async def service_dependency_viewer(self):
        c = wmi.WMI()
        services = {}
        for service in c.Win32_Service():
            services[service.Name] = [dep.Name for dep in service.DependentServices()]
        report = "\n".join(f"{name}: {', '.join(deps) if deps else 'None'}" for name, deps in services.items())
        output_file = os.path.join(self.backup_dir, f"service_dependencies_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(output_file, "w") as f:
            f.write(report)
        webbrowser.open(output_file)
        return "Dependencies Viewed"

    async def iot_device_management_gui(self):
        iot_window = tk.Toplevel(self.root)
        iot_window.title("IoT Device Management (Simulation)")
        iot_window.geometry("600x400")
        ttk.Label(iot_window, text="Simulated IoT Devices on Network:").pack(pady=5)
        tree = ttk.Treeview(iot_window, columns=("Name", "IP", "Status"), show="headings")
        tree.heading("Name", text="Device Name")
        tree.heading("IP", text="IP Address")
        tree.heading("Status", text="Status")
        tree.pack(fill="both", expand=True)
        # Simulated IoT devices
        devices = [("Smart Light", "192.168.1.101", "Online"), ("Thermostat", "192.168.1.102", "Online")]
        for device in devices:
            tree.insert("", "end", values=device)
        ttk.Button(iot_window, text="Secure Devices", 
                  command=lambda: self.run_in_thread(self.iot_device_management)).pack(pady=5)

    async def iot_device_management(self):
        # Simulation: Real IoT management requires network protocols
        messagebox.showinfo("IoT Management", "Simulated securing of IoT devices")
        return "IoT Devices Managed"

    async def ai_voice_assistant_simulation(self):
        voice_window = tk.Toplevel(self.root)
        voice_window.title("AI Voice Assistant (Simulation)")
        voice_window.geometry("400x300")
        ttk.Label(voice_window, text="Voice Command Simulation:").pack(pady=5)
        cmd_var = tk.StringVar()
        ttk.Entry(voice_window, textvariable=cmd_var).pack(pady=5, fill="x")
        ttk.Button(voice_window, text="Execute", 
                  command=lambda: self.run_in_thread(lambda: self.execute_voice_command(cmd_var.get()))).pack(pady=5)
        ttk.Label(voice_window, text="Supported Commands: 'optimize', 'flush dns', 'clean'").pack(pady=5)

    async def execute_voice_command(self, command: str):
        cmd_map = {
            "optimize": self.optimize_system,
            "flush dns": self.flush_dns,
            "clean": self.clean_system_drive
        }
        cmd = command.lower()
        if cmd in cmd_map:
            await cmd_map[cmd]()
            messagebox.showinfo("Voice Command", f"Executed: {command}")
            return f"Voice Command '{command}' Executed"
        raise Exception(f"Unsupported voice command: {command}")

    async def blockchain_privacy_simulation(self):
        # Simulation: Real blockchain requires external service
        settings = {
            "telemetry": "disabled",
            "privacy_level": "high"
        }
        encrypted_settings = CIPHER.encrypt(json.dumps(settings).encode())
        output_file = os.path.join(self.backup_dir, f"blockchain_privacy_{datetime.now().strftime('%Y%m%d_%H%M%S')}.enc")
        with open(output_file, "wb") as f:
            f.write(encrypted_settings)
        messagebox.showinfo("Blockchain Privacy", "Simulated blockchain-based privacy enhancement")
        return "Privacy Enhanced"

    # Plugins Tab
    def setup_plugins_tab(self):
        frame = ttk.LabelFrame(self.tabs["Plugins"], text="Plugin Management")
        frame.pack(fill="both", expand=True, padx=5, pady=5)
        ttk.Button(frame, text="Load Plugin", 
                  command=lambda: self.run_in_thread(self.load_plugin_gui)).pack(pady=3, fill="x")
        ttk.Label(frame, text="Installed Plugins:").pack(pady=5)
        self.plugin_tree = ttk.Treeview(frame, columns=("Name", "Path"), show="headings")
        self.plugin_tree.heading("Name", text="Plugin Name")
        self.plugin_tree.heading("Path", text="Path")
        self.plugin_tree.pack(fill="both", expand=True)
        ttk.Button(frame, text="Run Selected Plugin", 
                  command=lambda: self.run_in_thread(lambda: self.run_plugin(self.plugin_tree.item(self.plugin_tree.selection())["values"][0]))).pack(pady=5)
        self.refresh_plugins()

    async def load_plugin_gui(self):
        plugin_path = filedialog.askopenfilename(filetypes=[("Python Files", "*.py")])
        if plugin_path:
            await self.load_plugin(plugin_path)
            self.refresh_plugins()
        return "Plugin Loaded"

    async def load_plugin(self, plugin_path: str):
        plugin_name = os.path.splitext(os.path.basename(plugin_path))[0]
        dest_path = os.path.join(self.plugin_dir, f"{plugin_name}.py")
        shutil.copy(plugin_path, dest_path)
        c = self.db_conn.cursor()
        c.execute("INSERT OR REPLACE INTO plugins (name, path) VALUES (?, ?)", (plugin_name, dest_path))
        self.db_conn.commit()
        return f"Loaded {plugin_name}"

    def refresh_plugins(self):
        for item in self.plugin_tree.get_children():
            self.plugin_tree.delete(item)
        c = self.db_conn.cursor()
        c.execute("SELECT name, path FROM plugins")
        for row in c.fetchall():
            self.plugin_tree.insert("", "end", values=(row[0], row[1]))

    async def run_plugin(self, plugin_name: str):
        c = self.db_conn.cursor()
        c.execute("SELECT path FROM plugins WHERE name = ?", (plugin_name,))
        result = c.fetchone()
        if result:
            plugin_path = result[0]
            spec = importlib.util.spec_from_file_location(plugin_name, plugin_path)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            if hasattr(module, "run"):
                await self.loop.run_in_executor(None, module.run)
                return f"Plugin {plugin_name} Executed"
            raise Exception(f"Plugin {plugin_name} has no 'run' function")
        raise Exception(f"Plugin {plugin_name} not found")

    # Background Tasks
    async def update_dashboard(self):
        while self.running:
            self.cpu_var.set(f"CPU: {psutil.cpu_percent(interval=1):.1f}%")
            self.ram_var.set(f"RAM: {psutil.virtual_memory().percent:.1f}%")
            self.disk_var.set(f"Disk: {psutil.disk_usage('/').percent:.1f}%")
            await asyncio.sleep(2)

    async def run_background_tasks(self):
        while self.running:
            try:
                c = self.db_conn.cursor()
                c.execute("SELECT id, task, interval, last_run FROM schedules")
                for row in c.fetchall():
                    id, task, interval, last_run = row
                    if time.time() - last_run >= interval * 60:
                        func = getattr(self, task.lower().replace(" ", "_"), None)
                        if func:
                            await func()
                            c.execute("UPDATE schedules SET last_run = ? WHERE id = ?", (time.time(), id))
                self.db_conn.commit()
            except sqlite3.Error as e:
                logging.error(f"Background task error: {e}")
            await asyncio.sleep(30)

    # Cleanup on Exit
    def __del__(self):
        self.running = False
        self.loop.stop()
        self.db_conn.close()
        self.process_pool.shutdown()

# CLI Mode
if "--cli" in sys.argv:
    async def cli_mode():
        optimizer = SystemOptimizer(tk.Tk())
        try:
            command = sys.argv[sys.argv.index("--cli") + 1]
            await getattr(optimizer, command.lower().replace(" ", "_"))()
        except (IndexError, AttributeError) as e:
            print(f"Usage: {sys.argv[0]} --cli <command>")
            print("Available commands: optimize_system, flush_dns, etc.")
            sys.exit(1)
    asyncio.run(cli_mode())
    sys.exit(0)

# Recovery Mode
if "--recover" in sys.argv:
    async def recovery_mode():
        optimizer = SystemOptimizer(tk.Tk())
        await optimizer.run_silent_optimization()
        print("Recovery optimization completed")
    asyncio.run(recovery_mode())
    sys.exit(0)

# Main Execution
if __name__ == "__main__":
    # Handle Ctrl+C gracefully
    def signal_handler(sig, frame):
        print("Shutting down...")
        sys.exit(0)
    signal.signal(signal.SIGINT, signal_handler)

    root = tk.Tk()
    app = SystemOptimizer(root)
    root.protocol("WM_DELETE_WINDOW", lambda: (setattr(app, 'running', False), root.quit()))
    root.mainloop()

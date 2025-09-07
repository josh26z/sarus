# Usage Guide: sarus & sarus-ui

This document provides detailed instructions on how to use the sarus command-line tool and its graphical counterpart, sarus-ui.

---

## Table of Contents

- [The sarus CLI Tool](#the-sarus-cli-tool)
  - [Basic Syntax](#basic-syntax)
  - [Interactive Mode](#interactive-mode)
  - [Command-Line Mode](#command-line-mode)
  - [Scan Types](#scan-types)
  - [Examples](#examples)
- [The sarus-ui GUI Tool](#the-sarus-ui-gui-tool)
  - [Launching the GUI](#launching-the-gui)
  - [Step-by-Step Guide](#step-by-step-guide)
  - [Understanding the Results](#understanding-the-results)
- [Tips & Best Practices](#tips--best-practices)

---

## 1. The sarus CLI Tool

The command-line interface is designed for speed, automation, and integration into scripts.

### Basic Syntax

The general command structure is:

```bash
sarus [network_prefix] [start_host] [end_host] [options]
```

### Interactive Mode

If you run sarus without any arguments, it will guide you through the setup with prompts.

```bash
sarus
```
You will be asked for:

- **Network Prefix:** (e.g., `192.168.1`)
- **Start Host:** The first host in the range (e.g., `1`)
- **End Host:** The last host in the range (e.g., `254`)
- **Scan Type:** Choose between Ping or TCP SYN scan.

### Command-Line Mode

For automation and faster execution, provide all parameters directly.

Scan a network range:

```bash
sarus 192.168.1 1 254
```

Perform a TCP scan on a specific port:

```bash
sarus 192.168.1 1 100 -t 443
# or
sarus 192.168.1 1 100 --tcp 80
```

Show the help menu:

```bash
sarus --help
```

### Scan Types

| Flag               | Description                              | Example                             |
|--------------------|------------------------------------------|-------------------------------------|
| (none)             | Default Ping (ICMP) scan.                | sarus 192.168.1 1 10                |
| -t [PORT]<br>--tcp [PORT] | TCP SYN Scan on a specific port. Requires nmap and sudo. | sarus 10.0.0 50 150 -t 22           |

### Examples (CLI)

**Example 1:** Find all active hosts on a local network.

```bash
sarus 192.168.1 1 254
```

**Example 2:** Check if hosts 50-100 have web servers (port 80) running.

```bash
sudo sarus 192.168.1 50 100 -t 80
```
*Note: TCP scanning often requires root privileges (`sudo`).*

**Example 3:** Quickly check a small range of hosts.

```bash
sarus 10.0.0.0 1 10
```

---

## 2. The sarus-ui GUI Tool

The graphical interface is perfect for beginners and for quick, interactive scans without remembering commands.

### Launching the GUI

You can start the GUI from the terminal or your application menu.

**From the terminal:**

```bash
sarus-ui
```

**From the application menu:**

Search for "sarus" or "Network Scanner" in your system's application launcher.

### Step-by-Step Guide (GUI)

1. **Launch the Application:** Open `sarus-ui`.
2. **Fill in the Form:**
    - **Network Prefix:** Enter the first three octets of your IP (e.g., `192.168.1`).
    - **Start Host:** The beginning of your range (e.g., `1`).
    - **End Host:** The end of your range (e.g., `254`).
    - **TCP Port:** If you selected "TCP SYN" scan, specify the port to check (e.g., `22` for SSH).
    - **Scan Type:** Choose between Ping or TCP SYN scan.
    - **Timeout:** Adjust how long to wait for a response (default is usually fine).
3. **Confirm:** Click "OK" to start the scan. A progress window will appear.
4. **Review Results:** Once complete, results will be shown in a scrollable window. You can save them to a text file using the checkbox provided.

### Understanding the Results

- **Active Hosts** will be clearly marked (e.g., `[+] Host 192.168.1.5 is ACTIVE`).
- **Open Ports** will be displayed with the service information from nmap.
- **Inactive Hosts** are typically hidden by default to reduce clutter.

---

## 3. Tips & Best Practices

- **Start Small:** When testing, scan a small range (e.g., 1-10) first to verify your command and avoid flooding the network.
- **Use sudo for TCP Scans:** TCP SYN scanning (`-t` flag) requires raw socket privileges, which usually means you need to run sarus with `sudo`.
- **Respect Networks:** Only scan networks you own or have explicit permission to test. Unauthorized scanning is often considered hostile.
- **GUI for Exploration, CLI for Automation:** Use sarus-ui to learn and explore. Use the sarus CLI in scripts or for automated tasks.
- **Check the Help:** Both tools have built-in help. Use `sarus --help` for a quick reference.

---

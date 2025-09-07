# sarus: The Vigilant Network Discovery Tool

**sarus** is a powerful, lightweight command-line interface (CLI) tool designed for network reconnaissance and host discovery. Built for cybersecurity professionals, system administrators, and networking enthusiasts, it provides fast and reliable scanning capabilities directly from the terminal.

---

## Core Features

- **Ping Sweeps:** Rapid ICMP (ping) scanning to identify active hosts on a network.
- **TCP SYN Scans:** Stealthy TCP port scanning using nmap to discover open services.
- **Flexible Targeting:** Scan custom IP ranges with precise control.
- **User-Friendly CLI:** Intuitive commands with helpful prompts and color-coded output.
- **Cross-Platform:** Optimized for Kali Linux and compatible with most Linux distributions.

---

## Ideal For

- Penetration testers
- Network auditors
- Anyone who needs quick, scriptable network discovery from the command line

---

## Usage Example

```bash
# Discover active hosts in a range
sarus 192.168.1.1 1 254

# Perform a TCP scan on port 443
sarus 10.0.0.0 1 100 -t 443
```

---

# sarus-ui: The Graphical Companion

**sarus-ui** is the official graphical user interface (GUI) for the sarus tool. It provides all the power of the CLI wrapped in an intuitive, point-and-click interface, making network scanning accessible to users of all experience levels.

---

## Core Features

- **Visual Network Discovery:** Input scan parameters through easy-to-use forms and dialogs.
- **Real-Time Progress Tracking:** Watch scans unfold with live progress bars and status updates.
- **Results Management:** View findings in a clean, scrollable window with options to save results to a file.
- **One-Click Launching:** Includes a desktop entry for quick access from your application menu.
- **Built with Zenity/YAD:** Leverages native Linux dialog tools for a lightweight footprint.

---

## Ideal For

- Beginners learning network security
- Professionals who prefer visual tools
- Quick interactive scans without memorizing commands

---

## Usage Example

```bash
# Launch the graphical interface
sarus-ui
```
(No commands needed—just configure and click!)

---

# The sarus Suite: Strength in Diversity

Together, **sarus** and **sarus-ui** form a complete network discovery suite:

- Use **sarus** for automation, scripting, and remote operations.
- Use **sarus-ui** for interactive exploration, training, and quick visual assessments.

Both tools share the same core scanning engine, ensuring consistent and reliable results regardless of how you choose to interact with them.

Named after the vigilant Sarus Crane, this project embodies the principles of height, perspective, and precision in network reconnaissance.

---

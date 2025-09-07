# sarus CLI Installation Guide

## Requirements

- Linux (Kali Linux recommended; most distributions supported)
- `nmap` installed for TCP SYN scan functionality
- ICMP/ TCP ping support (requires root for some operations)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/josh26z/sarus.git
cd sarus
```

### 2. Install Dependencies

Ensure `nmap` is installed:

```bash
sudo apt update
sudo apt install nmap
```



### 3. Make sarus Executable


```bash
chmod +x sarus.py
```


Move it to a directory in your `$PATH`:

```bash
sudo mv sarus /usr/local/bin/
```

### 4. Run sarus

```bash
sarus 192.168.1.1 1 254
```

or

```bash
sarus 10.0.0.0 1 100 -t 443
```

## Uninstallation

Simply remove the binary/script and symlink if created:

```bash
sudo rm /usr/local/bin/sarus
```

## Troubleshooting

- Ensure you have root privileges for ping sweeps.
- Confirm `nmap` is installed for TCP scans.

---

Enjoy fast, scriptable network discovery with sarus!

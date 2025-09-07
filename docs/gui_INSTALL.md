# sarus-ui GUI Installation Guide

## Requirements

- Linux distribution (Kali Linux recommended; most distributions supported)
- `zenity` (for graphical dialogs)
- sarus CLI installed (recommended for full functionality)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/josh26z/sarus.git
cd sarus
```

### 2. Install GUI Dependencies

Install `zenity`:

```bash
sudo apt update
sudo apt install zenity
```

### 3. Make sarus-ui Executable



```bash
chmod +x sarus-ui.sh
```

Optionally, symlink to a directory in your `$PATH`:


Move it to a directory in your `$PATH`:

```bash
sudo mv sarus-ui /usr/local/bin/
```

### 4. Desktop Entry (Optional)

To add sarus-ui to your application menu, create a desktop entry:

```bash
cat <<EOF | sudo tee /usr/share/applications/sarus-ui.desktop
[Desktop Entry]
Name=sarus-ui
Comment=Graphical frontend for sarus network discovery
Exec=/usr/local/bin/sarus-ui
Icon=network-wired
Terminal=false
Type=Application
Categories=Network;Utility;
EOF
```

### 5. Run sarus-ui

```bash
sarus-ui
```

Just configure scan parameters in the graphical dialog and click!

## Troubleshooting

- Ensure `zenity`  is installed and working.
- sarus CLI should be installed for full scanning capabilities.
- If desktop entry does not appear, run `update-desktop-database`.

---

Experience intuitive, visual network discovery with sarus-ui!

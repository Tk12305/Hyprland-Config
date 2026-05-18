#!/bin/bash
# Hyprland Config Install Script
# github.com/Tk12305/Hyprland-Config
# Run this on a fresh Arch Linux install

set -e

echo "======================================"
echo "  Hyprland Config Installer"
echo "======================================"
echo ""

# ── 1. Check for yay ──────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
    echo "[*] Installing yay (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~
else
    echo "[✓] yay already installed"
fi

# ── 2. Pacman packages ────────────────────────────────────────────
echo ""
echo "[*] Installing pacman packages..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    hyprlock \
    hypridle \
    hyprpaper \
    hyprcursor \
    xdg-desktop-portal-hyprland \
    waybar \
    rofi \
    dunst \
    kitty \
    grim \
    slurp \
    cliphist \
    wl-clipboard \
    nautilus \
    nwg-displays \
    polkit \
    pipewire \
    pipewire-audio \
    pipewire-pulse \
    pipewire-jack \
    wireplumber \
    gst-plugin-pipewire \
    rofi-power-menu \
    git \
    curl \
    wget \
    unzip

# ── 3. AUR packages ───────────────────────────────────────────────
echo ""
echo "[*] Installing AUR packages..."
yay -S --needed --noconfirm \
    hyprland-guiutils \
    hyprwire

# ── 4. Fonts ──────────────────────────────────────────────────────
echo ""
echo "[*] Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji

yay -S --needed --noconfirm \
    ttf-cinzel \
    ttf-nunito

# ── 5. Clone repo ─────────────────────────────────────────────────
echo ""
echo "[*] Cloning Hyprland-Config repo..."
REPO_DIR="$HOME/Hyprland-Config"
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/Tk12305/Hyprland-Config.git "$REPO_DIR"
else
    echo "[✓] Repo already cloned, pulling latest..."
    git -C "$REPO_DIR" pull
fi

# ── 6. Create config directories ─────────────────────────────────
echo ""
echo "[*] Creating config directories..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar/scripts
mkdir -p ~/.config/rofi
mkdir -p ~/Pictures
mkdir -p ~/Wallpapers

# ── 7. Symlink configs ────────────────────────────────────────────
echo ""
echo "[*] Symlinking configs..."

# Hyprland
ln -sf "$REPO_DIR/hyprland.conf"   ~/.config/hypr/hyprland.conf
ln -sf "$REPO_DIR/hyprlock.conf"   ~/.config/hypr/hyprlock.conf
ln -sf "$REPO_DIR/hypridle.conf"   ~/.config/hypr/hypridle.conf
ln -sf "$REPO_DIR/hyprpaper.conf"  ~/.config/hypr/hyprpaper.conf
ln -sf "$REPO_DIR/monitors.conf"   ~/.config/hypr/monitors.conf
ln -sf "$REPO_DIR/workspaces.conf" ~/.config/hypr/workspaces.conf

# Waybar
ln -sf "$REPO_DIR/config.jsonc"    ~/.config/waybar/config.jsonc
ln -sf "$REPO_DIR/style.css"       ~/.config/waybar/style.css
ln -sf "$REPO_DIR/albumart.css"    ~/.config/waybar/albumart.css

# Waybar scripts
for script in "$REPO_DIR/scripts/"*; do
    ln -sf "$script" ~/.config/waybar/scripts/$(basename "$script")
    chmod +x "$script"
done

# Rofi
ln -sf "$REPO_DIR/rofi/lunar.rasi"    ~/.config/rofi/lunar.rasi
ln -sf "$REPO_DIR/rofi/config.rasi"   ~/.config/rofi/config.rasi
ln -sf "$REPO_DIR/rofi/fonts.rasi"    ~/.config/rofi/fonts.rasi
ln -sf "$REPO_DIR/rofi/wifi.rasi"     ~/.config/rofi/wifi.rasi
ln -sf "$REPO_DIR/rofi/wifi-menu.sh"  ~/.config/rofi/wifi-menu.sh
chmod +x "$REPO_DIR/rofi/wifi-menu.sh"

# Wallpapers
cp "$REPO_DIR/wallpaper/"*           ~/Wallpapers/ 2>/dev/null || true
cp "$REPO_DIR/"*.jpg                 ~/Wallpapers/ 2>/dev/null || true
cp "$REPO_DIR/"*.png                 ~/Wallpapers/ 2>/dev/null || true

# ── 8. Enable PipeWire services ───────────────────────────────────
echo ""
echo "[*] Enabling PipeWire user services..."
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber

# ── 9. Done ───────────────────────────────────────────────────────
echo ""
echo "======================================"
echo "  Install complete!"
echo "======================================"
echo ""
echo "  Next steps:"
echo "  1. Edit ~/.config/hypr/monitors.conf for your display"
echo "  2. Edit ~/.config/hypr/hyprpaper.conf for your wallpaper path"
echo "  3. Log out and select Hyprland from your display manager"
echo "  4. Or run: Hyprland"
echo ""

#!/usr/bin/env bash
# macOS system settings that differ from defaults on the old Mac.
set -euo pipefail

# Appearance + text
defaults write -g AppleInterfaceStyle -string Dark
defaults write -g AppleShowAllExtensions -bool true

# Dock: autohide, small, no launch bounce, no recents; bottom-right hot corner = Quick Note
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 39
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock wvous-br-corner -int 14

# Finder: column view, path + status bar, search current folder, new window = home
defaults write com.apple.finder FXPreferredViewStyle -string clmv
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Screenshots: window style, show clicks in recordings
defaults write com.apple.screencapture style -string window
defaults write com.apple.screencapture showsClicks -bool true

# Menu-bar clock: analog, date hidden (Itsycal shows it)
defaults write com.apple.menuextra.clock IsAnalog -bool true
defaults write com.apple.menuextra.clock ShowDate -int 2

killall Dock Finder SystemUIServer 2>/dev/null || true

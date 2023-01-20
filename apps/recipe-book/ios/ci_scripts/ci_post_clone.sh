#!/bin/sh

HOMEBREW_NO_AUTO_UPDATE=1 

# Install CocoaPods using Homebrew.
brew install cocoapods

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Run Flutter doctor
flutter doctor

# Get packages
flutter packages get

# Update generated files
flutter pub run build_runner build

# Build ios app
flutter build ios --no-codesign
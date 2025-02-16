# 🐳 Docker Compose Creator

A modern, intuitive GUI application for creating and managing Docker Compose files.

![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.6.0-red.svg)
![Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-red.svg)
![License](https://img.shields.io/badge/license-Custom_Open_Source-blue.svg)

## ✨ Features

- 📝 Visual Docker Compose file editor
- 🔄 Real-time YAML preview
- 🛠️ Advanced service configuration
- 📱 Responsive design

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (≥3.6.0)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/composecreator.git

# Navigate to project directory
cd composecreator

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🎯 Usage

1. Launch the application
2. Click "Add Service" to create a new service
3. Configure your service settings:
   - Basic Configuration (image, command, etc.)
   - Environment Variables
   - Networking
   - Storage
   - Advanced Settings
4. Export your docker-compose file


## 🛠️ Development

### Project Structure

```
lib/
├── models/
├── screens/
├── widgets/
└── main.dart
```

### Building

```bash
# Build for Windows
flutter build windows

# Create Windows Installer
# 1. Install Inno Setup from https://jrsoftware.org/isdl.php
# 2. Run the following command:
iscc installer.iss

# Build for macOS
flutter build macos

# Build for Linux
flutter build linux
```

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Docker for the inspiration

## 🔮 Future Plans

- Network topology visualization
- Docker Hub integration
- Service templates
- Multi-file support
- Docker Swarm configurations

## 📜 License

This project is licensed under a Custom Open Source License - see the [LICENSE](LICENSE) file for details.
- You are free to use, modify, and distribute this software
- You cannot sell this software or any derivative works
- Credit to the original author (Darkobyte Software) must be maintained

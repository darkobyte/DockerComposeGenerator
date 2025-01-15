# 🐳 Docker Compose Creator

A modern, intuitive GUI application for creating and managing Docker Compose files.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.6.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey.svg)

## ✨ Features

- 📝 Visual Docker Compose file editor
- 🔄 Real-time YAML preview
- 🎨 Dark/Light theme support
- 🛠️ Advanced service configuration
- 📱 Responsive design
- 💾 Export to docker-compose.yml

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

## ⚙️ Configuration

### Settings

- **Layout**
  - Toggle YAML preview
  - Show/hide version
  
- **Editor**
  - Auto-save
  - Default Docker Compose version
  
- **Appearance**
  - Dark/Light mode
  - Font size adjustment
  
- **Advanced**
  - Experimental features

## 🛠️ Development

### Project Structure

```
lib/
├── models/
│   ├── app_settings.dart
│   └── docker_service.dart
├── screens/
│   ├── home_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── service_box.dart
│   └── yaml_editor.dart
└── main.dart
```

### Building

```bash
# Build for Windows
flutter build windows

# Build for macOS
flutter build macos

# Build for Linux
flutter build linux
```

## 📝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Docker for the inspiration
- All contributors who helped shape this project

## 🔮 Future Plans

- Network topology visualization
- Docker Hub integration
- Service templates
- Multi-file support
- Docker Swarm configurations

## 📫 Contact

Your Name - [@yourtwitterhandle](https://twitter.com/yourtwitterhandle)

Project Link: [https://github.com/yourusername/composecreator](https://github.com/yourusername/composecreator)

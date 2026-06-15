# usmart - Smart Umbrella Control Application

![Logo](assets/logo/Screenshot_2026-04-30_at_9.08.31_PM-removebg-preview.png)

A sophisticated Flutter application for controlling an intelligent beach umbrella with real-time monitoring, RGB lighting control, audio management, and solar battery tracking.

---

## Overview

usmart is an enterprise-grade Flutter application designed to seamlessly control and monitor a smart umbrella device. The application provides a modern, responsive interface for managing umbrella position, ambient lighting, sound system, and battery health through an intuitive dashboard with advanced state management using Riverpod.

**Demo Video:** Watch the application in action

[![Watch the demo](assets/logo/Screenshot_2026-04-30_at_9.08.31_PM-removebg-preview.png)](assets/video/WhatsApp%20Video%202026-06-15%20at%201.56.50%20PM.mp4)

---

## Key Features

### Core Functionality

- **Umbrella Control** - Open, close, and stop umbrella movements with real-time position feedback
- **RGB Lighting System** - Adjust color, brightness, and lighting modes (static, ambient, party)
- **Sound Management** - Control music playback and volume levels with intuitive controls
- **Battery Monitoring** - Track battery percentage, charging status, and solar panel output
- **Solar Integration** - Monitor solar panel power generation and automatic charging optimization
- **Connection Management** - Real-time device connectivity status with offline detection

### User Experience

- **Responsive Dashboard** - Premium dashboard with aurora header, parallax scrolling, and quick controls
- **Dark & Light Themes** - Full support for both light and dark modes with smooth transitions
- **Floating Island Navigation** - Modern bottom navigation bar with glass morphism design
- **Smooth Animations** - Sophisticated animations powered by flutter_animate for premium feel
- **Profile Management** - User profile integration with personalization options
- **Accessibility** - Support for multiple screen sizes and orientations

### Development Features

- **Simulation Mode** - Built-in device simulation for development and testing without hardware
- **Debug Screen** - Comprehensive debugging interface for developers
- **Comprehensive Error Handling** - Custom exception hierarchy for reliable error management
- **Type Safety** - Full type annotations for enhanced code quality and IDE support

---

## Architecture

### Technical Stack

```
Frontend Layer
    |
State Management (Riverpod)
    |
Device Interface Abstraction
    |
Communication Service Layer
    |
Hardware/Simulation
```

### Core Components

**lib/core/** - Foundation layer
- Navigation system using GoRouter with StatefulShellRoute
- Application theme and color system
- Shared utilities and helper functions
- Reusable UI components (AppShell, GlassCard, etc.)

**lib/device/** - Hardware abstraction
- UmbrellaDeviceInterface - Unified device communication contract
- FakeUmbrellaDevice - Simulation implementation for development
- ESP32UmbrellaDevice - Real hardware implementation (in development)
- Device state models with immutable data classes

**lib/state/** - State management
- Riverpod providers for application state
- Device connection notifiers
- Feature-specific providers (battery, lighting, sound, etc.)

**lib/features/** - Feature modules
- Dashboard - Main control interface
- Lighting - RGB lighting configuration
- Sound - Audio system management
- Battery - Power and solar monitoring
- Settings - Application preferences
- Profile - User account management
- Onboarding - First-run user experience
- Debug - Developer tools

---

## Project Structure

```
usmart/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── core/
│   │   ├── constants/            # App-wide constants and routes
│   │   ├── navigation/           # GoRouter configuration
│   │   ├── services/             # Communication abstractions
│   │   ├── theme/                # Colors and typography
│   │   ├── utils/                # Helper functions
│   │   └── widgets/              # Reusable UI components
│   ├── device/
│   │   ├── umbrella_device_interface.dart
│   │   ├── fake_umbrella_device.dart
│   │   ├── esp32_umbrella_device.dart
│   │   └── models/
│   │       └── umbrella_state.dart
│   ├── features/
│   │   ├── dashboard/
│   │   ├── lighting/
│   │   ├── sound/
│   │   ├── battery/
│   │   ├── settings/
│   │   ├── profile/
│   │   ├── onboarding/
│   │   └── debug/
│   ├── page/
│   │   └── splash.dart
│   └── state/                    # Riverpod providers
├── assets/
│   ├── images/
│   ├── icons/
│   ├── logo/
│   ├── video/
│   └── fonts/
├── android/                      # Android platform code
├── ios/                          # iOS platform code
├── linux/                        # Linux platform code
├── macos/                        # macOS platform code
├── windows/                      # Windows platform code
├── web/                          # Web platform code
├── test/                         # Test files
├── pubspec.yaml                  # Dependencies and project configuration
└── analysis_options.yaml         # Code analysis rules
```

---

## Getting Started

### Prerequisites

- Flutter 3.10.7 or higher
- Dart 3.10.7 or higher
- Xcode 14.0+ (for iOS development)
- Android SDK 21+ (for Android development)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/usmart.git
cd usmart
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code (Riverpod generators)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the application
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### Running on Different Platforms

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d web

# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

---

## Usage

### Starting the Application

1. Launch the app on your device or emulator
2. The splash screen will appear followed by the dashboard
3. Device connectivity status displays at the top of the dashboard

### Dashboard Features

**Connection Status** - Real-time indicator of device connectivity state

**Umbrella Control** - Primary card for opening/closing umbrella with current state display

**Battery Status** - Quick view of battery percentage and charging status

**Quick Controls** - One-tap access to lighting and sound controls

**Statistics** - Connection uptime and feature status overview

### Navigation

Use the floating island navigation bar at the bottom to access:
- Home (Dashboard)
- Lighting Control
- Sound Management
- Battery Monitoring

Access additional features through the dashboard menu:
- Settings
- Profile
- Debug Tools (development only)

### Simulation Mode

For development without hardware:
1. The app defaults to simulation mode
2. Open Debug screen to toggle between simulation and real device
3. Device responds to commands in real-time for testing

---

## State Management

The application uses **Riverpod** for state management with the following structure:

### Core Providers

**deviceProvider** - Manages device instance (simulated or real)
**isConnectedProvider** - Device connectivity status
**batteryStateProvider** - Battery and solar power information
**lightingStateProvider** - Lighting configuration and status
**soundStateProvider** - Audio system state
**themeModeProvider** - Light/dark theme preference

### Data Flow

```
Device Interface
    |
State Stream (deviceStateStreamProvider)
    |
Feature Providers (battery, lighting, sound)
    |
UI Components (rebuild on state change)
```

---

## Device Communication

The application abstracts device communication through multiple layers:

### Communication Service (Planned)
- **BleCommunicationService** - Bluetooth Low Energy support
- **WifiCommunicationService** - TCP socket communication
- **WebSocketCommunicationService** - WebSocket protocol

### Device Interface Contract

All device implementations must provide:
- Connection management (connect/disconnect)
- Umbrella control (open/close/stop)
- Lighting control (color, brightness, mode)
- Sound management (play/pause, volume)
- Status monitoring (state stream, current state)

---

## Development

### Code Generation

Riverpod providers use code generation. After modifying providers:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Code Quality

Analyze code for issues:
```bash
flutter analyze
```

Apply lint rules:
```bash
dart fix --apply
```

Format code:
```bash
dart format lib/
```

### Adding New Features

1. Create feature directory under `lib/features/`
2. Add presentation layer screens and widgets
3. Create Riverpod providers in `lib/state/` if needed
4. Add routes to `lib/core/navigation/app_router.dart`
5. Integrate with device provider if hardware control needed

### Theme Customization

Modify `lib/core/theme/app_colors.dart` and `lib/core/theme/app_theme.dart` to customize:
- Color palette
- Typography
- Component styling
- Dark/light mode variants

---

## Dependencies

### Core Framework
- **flutter** - UI framework
- **flutter_riverpod** - State management
- **riverpod_annotation** - Code generation annotations

### Navigation & Routing
- **go_router** - Modern routing with deep linking support

### Storage & Persistence
- **shared_preferences** - Local key-value storage

### UI & Design
- **google_fonts** - Typography library
- **flutter_animate** - Animation effects
- **flex_color_picker** - Color selection widget
- **cupertino_icons** - iOS-style icons

### Utilities
- **uuid** - Unique identifier generation
- **intl** - Internationalization support

### Development
- **flutter_lints** - Dart code analysis
- **build_runner** - Code generation tool
- **flutter_launcher_icons** - Icon generation

---

## Known Limitations & Future Work

### In Development
- ESP32 hardware implementation pending
- Complete BLE communication service
- WiFi and WebSocket protocols
- Real device testing and optimization

### Planned Features
- Cloud synchronization for user settings
- Scheduled automation and routines
- Weather integration for automatic responses
- Multi-device support
- Advanced battery analytics
- Companion web application

---

## API Reference

### UmbrellaDeviceInterface

Key methods for device control:

```dart
// Connection
Future<bool> connect()
Future<void> disconnect()
bool get isConnected

// Umbrella Control
Future<void> openUmbrella()
Future<void> closeUmbrella()
Future<void> stopUmbrella()

// Lighting
Future<void> toggleLight(bool on)
Future<void> setRGBColor(Color color)
Future<void> setBrightness(int level)
Future<void> setLightingMode(LightingMode mode)

// Audio
Future<void> playMusic()
Future<void> pauseMusic()
Future<void> setVolume(int level)

// Status
Stream<UmbrellaDeviceState> get stateStream
UmbrellaDeviceState get currentState
```

---

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

---

## Error Handling

The application defines custom exceptions for robust error management:

- **DeviceNotConnectedException** - Device not currently connected
- **DeviceConnectionException** - Connection attempt failed
- **UmbrellaOperationException** - Umbrella command failed
- **DeviceTimeoutException** - Operation exceeded timeout
- **DeviceCommunicationException** - Communication protocol error

---

## Configuration

### Build Variants

Configure platform-specific builds in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/logo/
```

### Environment Variables

Use `.env` file for sensitive configuration (create locally, add to .gitignore):
```
DEVICE_MAC_ADDRESS=XX:XX:XX:XX:XX:XX
API_ENDPOINT=https://api.example.com
```

---

## Performance Optimization

- Lazy loading of feature modules
- Image caching and optimization
- State provider memoization
- Stream subscription management
- Animation frame rate optimization

---

## Troubleshooting

### Application won't connect to device
1. Verify device is powered on
2. Check device is within Bluetooth range
3. Confirm simulation mode is disabled in Debug screen
4. Review device logs for communication errors

### Animations are stuttering
1. Ensure device has sufficient resources
2. Check for background processes
3. Profile with Flutter DevTools
4. Reduce animation complexity if needed

### State not updating
1. Verify Riverpod provider is properly watched
2. Check device stream is emitting updates
3. Confirm state mutations are immutable
4. Review build method dependencies

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure:
- Code follows Flutter style guide
- All tests pass
- Code is properly documented
- No breaking changes without discussion

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact & Support

For questions, bug reports, or feature requests:
- Create an issue on GitHub
- Submit a pull request with improvements
- Contact the development team

---

## Acknowledgments

Built with:
- Flutter framework and ecosystem
- Riverpod state management
- GoRouter navigation
- Material Design principles
- The wonderful Flutter community

---

## Version History

**v1.0.0** (Current)
- Initial release with core functionality
- Dashboard with real-time monitoring
- Lighting and sound control
- Battery and solar tracking
- Multi-platform support

---

## Quick Reference

| Feature | Status | Platform |
|---------|--------|----------|
| Dashboard | Active | All |
| Lighting Control | Active | All |
| Sound Management | Active | All |
| Battery Monitoring | Active | All |
| Device Simulation | Active | All |
| BLE Communication | Planned | iOS, Android |
| WiFi Communication | Planned | All |
| Cloud Sync | Planned | All |
| Automation | Planned | All |

---

*Last Updated: June 15, 2026*
*For more information, visit the [project repository](https://github.com/saifmostafa4664/project-X.git)*

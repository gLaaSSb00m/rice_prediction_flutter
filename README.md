# Rice Prediction Flutter App

A Flutter application that uses machine learning to predict rice varieties from images. The app leverages TensorFlow Lite for on-device inference, allowing users to select rice images and get instant predictions of the variety along with confidence scores.

## How the App Works

The Rice Prediction app provides a simple and intuitive interface for rice variety identification:

1. **Model Loading**: On app startup, the TensorFlow Lite model is loaded into memory for efficient inference.
2. **Image Selection**: Users can select images from their device gallery with proper permission handling.
3. **Image Preprocessing**: Selected images are resized to 224x224 pixels and normalized for model input.
4. **Inference**: The preprocessed image is fed into the TFLite model to generate predictions.
5. **Result Display**: The app displays the predicted rice variety with the highest confidence score.

## Components Used

### Core Framework
- **Flutter**: Cross-platform UI framework for building native mobile applications.

### Machine Learning
- **TensorFlow Lite Flutter Plugin (tflite_flutter)**: Enables running TensorFlow Lite models on Flutter apps for on-device inference.

### Image Handling
- **Image Picker**: Allows users to select images from the device gallery.
- **Image Package**: Used for image decoding, resizing, and preprocessing operations.

### Permissions
- **Permission Handler**: Manages photo gallery access permissions required for image selection.

### UI Components
- **Material Design**: Google's design system for consistent and intuitive user interfaces.
- **Cards and Buttons**: For displaying information and user interactions.

## Project Structure

```
rice_prediction_flutter/
├── android/                 # Android platform-specific code
├── ios/                     # iOS platform-specific code
├── lib/                     # Main Flutter application code
│   └── main.dart           # Main application file with UI and ML logic
├── assets/                  # Application assets
│   ├── rice_model.tflite   # TensorFlow Lite model for rice classification
│   ├── rice_model_1.tflite # Alternative model (if needed)
│   └── rice_model_2.tflite # Alternative model (if needed)
├── test/                    # Unit and widget tests
└── pubspec.yaml            # Project dependencies and configuration
```

## Supported Rice Varieties

The model can classify 62 different rice varieties including:

- Lal Aush, Jirashail, Gutisharna, Red Cargo, Najirshail
- Katarivog Polao, Lal Biroi, Chinigura Polao, Amondhan, Shorna5
- Subol Lota, Lal Binni, Arborio, Turkish Basmati, Ipsala
- Jasmine, Karacadag, BD series (BD30-BD95), Binadhan series (Binadhan7-Binadhan26)
- BR series (BR22-BRRI102), and many more traditional varieties

## Download APK

For users who want to install the app directly on Android devices without building from source, download the latest APK from the GitHub repository:

[Download RiceVision.apk](https://github.com/gLaaSSb00m/rice_prediction_flutter/raw/main/RiceVision.apk)

**Note**: Ensure you have enabled "Install unknown apps" in your Android settings to install APKs from external sources.

## Installation and Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio or Xcode for platform-specific development
- Device or emulator for testing

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/gLaaSSb00m/rice_prediction_flutter.git
   cd rice_prediction_flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Permissions
The app requires photo gallery access to select images. On first run, grant the necessary permissions when prompted.

## Technical Details

### Model Specifications
- **Input**: 224x224 RGB images
- **Output**: Probability scores for 62 rice classes
- **Framework**: TensorFlow Lite
- **Optimization**: Optimized for mobile deployment

### Image Preprocessing
- Resize to 224x224 pixels
- Normalize pixel values to [0, 1] range
- Convert to Float32 format for model input

### Performance
- On-device inference for privacy and speed
- No internet connection required for predictions
- Optimized for mobile hardware constraints

## Development

### Adding New Features
- Modify `lib/main.dart` for UI changes
- Update `pubspec.yaml` for new dependencies
- Add new models to `assets/` directory

### Testing
Run tests with:
```bash
flutter test
```

### Building for Production
- **Android APK**:
  ```bash
  flutter build apk --release
  ```
- **iOS**:
  ```bash
  flutter build ios --release
  ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- TensorFlow Lite team for the ML framework
- Flutter team for the cross-platform framework
- Rice variety dataset providers for the training data

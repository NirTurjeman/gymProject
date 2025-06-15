# GymProject

A simple iOS app for managing gym activities and sessions.

## Requirements

- Xcode 14 or later
- macOS 12 or later
- Swift 5.5 or later
- CocoaPods (if using external dependencies)
- An iOS device or simulator running iOS 15.0+
- You must be an Apple Developer (with a valid developer account) to use the NFC functionality in this app.
This is required to enable and test NFC features on a real device.

## Getting Started

1. **Clone the repository:**
https://github.com/NirTurjeman/gymProject

Then open the `.xcworkspace` file.

2. **Open the project:**
- Open `GymProject.xcodeproj` in Xcode.

4. **Configure the app:**
- Before running the app, set the `API_BASE_URL` environment variable in your Xcode scheme:
                                                                            
    1. Go to `Product > Scheme > Edit Scheme...`
    2. Select the `Run` section.
    3. Add a new environment variable:
        - Name: `API_BASE_URL`
        - Value: (your API base URL, e.g., `http://your_url:8081`)
        This allows the app to use the correct backend URL at runtime.

5. **Build and run:**
- Select a simulator or your device.
- Click the Run button in Xcode or press `Cmd+R`.

## Features

- Start and finish gym activities
- Track time and repetitions
- View activity details

## Notes

- Ensure all `@IBOutlet` connections are set in Interface Builder.
- If you encounter a crash related to optionals, check that all required properties are set before presenting view controllers.

## License

This project is for educational purposes.

## 📹 App Test Video

- [▶️ Unity Reps Demo](./Unity_Reps.mov)
- [▶️ Full App Test](./App_Test.mp4)

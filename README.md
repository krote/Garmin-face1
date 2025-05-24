# face1 Watch Face

A highly customizable watch face for Garmin devices, designed to provide a wealth of information at a glance.

## Features

*   **Time Display:**
    *   Current time with hours and minutes.
    *   Optional AM/PM indicator.
    *   Support for 12-hour and 24-hour (military) time formats. The 24-hour format includes a leading zero for hours (e.g., 08:00).
    *   Option to hide the seconds display (to save battery or for a cleaner look, especially on always-on displays).
*   **Battery Meter:**
    *   Customizable battery gauge.
    *   Battery level percentage display (can be hidden).
    *   Low battery level indication (e.g., the gauge or percentage text changes color to red or yellow).
*   **Data Fields:**
    *   Up to three configurable data fields to display various metrics.
*   **Goal Meters:**
    *   Two configurable goal meters (typically positioned on the left and right sides of the screen).
    *   Visually track progress towards daily goals.
*   **Weather Information:**
    *   Current weather conditions (requires location permission; uses OpenWeatherMap data, typically fetched via Garmin's services).
    *   Temperature display.
    *   Humidity display.
*   **Local City Time:**
    *   Display current time for a user-specified city.
*   **Customization:**
    *   Multiple color themes.
    *   Customizable background and foreground colors.
    *   Configurable styles for goal meters.
*   **Activity Tracking:**
    *   Displays data such as steps, distance, calories burned, floors climbed, and active minutes.
*   **Health Monitoring:**
    *   Heart rate display (current and optionally a live 5-second average).
*   **Other Information:**
    *   Sunrise and sunset times (requires location permission).
    *   Notification count.
    *   Alarms count.
    *   Altitude.
    *   Atmospheric pressure.
*   **Language Support:**
    *   Currently, the primary user interface is in English.
    *   The watch face includes a Japanese language declaration in its manifest and necessary CJK fonts, indicating planned support for Japanese and potentially other East Asian languages.
*   **Burn-in Protection:** For compatible display technologies (e.g., AMOLED), elements may shift periodically.

## Supported Devices

*   Garmin Forerunner 265 (fr265)
*   *(Other devices might be compatible but are not explicitly listed in the manifest. Check the Connect IQ store listing for the most up-to-date compatibility.)*

## Customization

You can customize the "face1" watch face through the Garmin Connect IQ app on your smartphone.

Available settings typically include:

*   **Theme:** Choose from several pre-defined color themes.
*   **Background Color:** Select from options like Black, Dark Gray, Light Gray, or White.
*   **Foreground Color:** Select from options like Black, Blue, Red, or White for primary text elements.
*   **Time Format:**
    *   **Force Military Format (24h with leading zero):** Toggle to ensure the time is displayed in 24-hour format with a leading zero (e.g., 08:00), potentially overriding the general device setting for time display. (Note: 12/24 hour format is often primarily governed by general device settings; this option fine-tunes the 24h display).
*   **Hide Seconds:** Toggle to show or hide the seconds display.
*   **Data Fields (up to 3):** Choose what information to display in each field:
    *   Sunrise/Sunset Time
    *   Heart Rate (Current)
    *   Heart Rate (Live 5s average)
    *   Battery Level (Percentage)
    *   Battery Level (Icon only, hiding percentage)
    *   Notification Count
    *   Calories Burned
    *   Distance Covered
    *   Alarm Count
    *   Current Altitude
    *   Temperature (from weather)
    *   Weather Conditions (Text or Icon)
    *   Atmospheric Pressure
    *   Humidity (from weather)
*   **Goal Meters (Left and Right):**
    *   **Data Types:**
        *   Steps
        *   Floors Climbed
        *   Active Minutes
        *   Calories
        *   Battery
        *   Off (hide meter)
    *   **Style:** Configure the appearance of the goal meters (e.g., segmented, continuous fill).
*   **Local Time in City:** Specify a city to display its local time.

## Weather and Location Features

*   "face1" can display current weather conditions, temperature, and humidity, typically provided by OpenWeatherMap via Garmin's weather services.
*   To use weather features and display sunrise/sunset times, you need to grant location (GPS) permission to the watch face via your Garmin device settings.
*   The watch face will periodically attempt to update weather data when it has a valid GPS location.
*   You can also set a specific city in the settings to display its local time; this is independent of the location used for weather data.

## Language Support

*   The user interface is currently available in **English**.
*   The application manifest declares support for **Japanese (`jpn`)** and includes various CJK (Chinese, Japanese, Korean) fonts. This indicates an intention to support these languages in the future, though Japanese (or other CJK) translations for UI elements might not yet be present in the current string resources.

## Installation

1.  Open the Garmin Connect IQ Store app on your smartphone.
2.  Search for "face1" (or the name it's published under).
3.  Select the watch face and tap "Download" or "Install".
4.  Sync your Garmin device with the Garmin Connect app.
5.  Once installed, you can select "face1" from the list of available watch faces on your device (usually by a long press on the current watch face, then navigating to find "face1").
6.  Customization is done via the Connect IQ app: find "face1" in your list of installed items, then go to its "Settings".

## Screenshots

*(It is highly recommended to add screenshots of the watch face in action here. These can be uploaded to the Connect IQ store page and/or embedded in this README if hosted on a platform like GitHub.)*

## Building from Source (for Developers)

This project uses Garmin's Monkey C SDK.
1.  Ensure you have the Garmin Connect IQ SDK installed and configured. Refer to the official Garmin documentation.
2.  Clone this repository (if applicable) or download the source code.
3.  Open the project in an IDE like Visual Studio Code with Garmin's "Monkey C" extension, or use Eclipse with the Garmin plugin.
4.  The main build configuration file is `monkey.jungle`.
5.  The application definition file is `manifest.xml`.
6.  Use the IDE commands (e.g., "Monkey C: Build Project" in VS Code) or the command-line compiler (`monkeyc`) to compile the project.
7.  Use the IDE commands (e.g., "Monkey C: Run App in Simulator" or "Monkey C: Build for Device & Sideload") or command-line tools (`monkeydo`) to deploy to a simulator or a connected device.

## Contributing

*(If you wish to accept contributions, outline the process here. For example:
"Contributions are welcome! Please fork the repository, create a new feature branch, make your changes, and then submit a pull request for review.")*

## License

*(Specify the license under which this project is released, e.g., MIT, Apache 2.0, GPL. If no license file is present in the repository, consider adding one. Example: "This project is licensed under the MIT License - see the LICENSE.md file for details.")*
```

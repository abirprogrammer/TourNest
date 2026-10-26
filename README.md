# 🌍 TourNest — Explore Bangladesh

<p align="center">
  <img src="assets/screenshots/home.png" alt="TourNest Home Screen" width="260">
</p>

<h3 align="center">Discover the Beauty of Bangladesh 🇧🇩</h3>

<p align="center">
  Your personal travel companion for discovering beautiful destinations, exploring nature, and planning your next adventure.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-34A853" alt="Platforms">
  <img src="https://img.shields.io/badge/Status-Development-orange" alt="Project Status">
</p>

---

## 📱 App Screenshots

Explore the TourNest interface through the screenshots below.

<p align="center">
  <img src="assets/screenshots/home.png" alt="Home Screen" width="250">
  &nbsp;&nbsp;
  <img src="assets/screenshots/search.png" alt="Search Destinations" width="250">
</p>

<p align="center">
  <b>Home Screen</b> &nbsp; | &nbsp; <b>Search Destinations</b>
</p>

<p align="center">
  <img src="assets/screenshots/destination_details.png" alt="Destination Details" width="250">
  &nbsp;&nbsp;
  <img src="assets/screenshots/favourites.png" alt="Favourite Destinations" width="250">
</p>

<p align="center">
  <b>Destination Details</b> &nbsp; | &nbsp; <b>Favourite Places</b>
</p>

<p align="center">
  <img src="assets/screenshots/travel_videos.png" alt="Travel Videos" width="250">
  &nbsp;&nbsp;
  <img src="assets/screenshots/booking_form.png" alt="Trip Request Form" width="250">
</p>

<p align="center">
  <b>Travel Videos</b> &nbsp; | &nbsp; <b>Trip Request Form</b>
</p>

> **Note:** Replace these screenshot files with actual screenshots captured from your running application. Remove any gallery entry for a screen that your app does not contain.

---

## ✨ Features

- 🏝️ **Explore Destinations** — Discover beautiful travel destinations across Bangladesh.
- 🔎 **Smart Search** — Search destinations by name, location, or category.
- 🗂️ **Category Filters** — Browse All, Beach, Hills, and Nature destinations.
- 🖼️ **Destination Cards** — View destination images, ratings, and essential information.
- ❤️ **Favourite Destinations** — Mark interesting places as favourites.
- 📍 **Destination Details** — Explore destination information, travel tips, and map links.
- 🎬 **Travel Videos** — Find destination-related videos through YouTube search.
- 🎟️ **Trip Request Form** — Enter your name, phone number, travel date, and number of travellers.
- 📱 **Responsive UI** — Scrollable layouts designed for a smooth mobile experience.
- 🌐 **Network Image Support** — Load destination images from online sources with fallback handling.

## 🗺️ Discover Bangladesh

TourNest is designed to make discovering Bangladesh easier, from relaxing beaches to green hills and peaceful natural destinations.

Explore destinations such as:

- Cox's Bazar
- Saint Martin's Island
- Sajek Valley
- Bandarban
- Rangamati
- Sylhet
- Sundarbans
- Kuakata

These are examples of destinations the app can feature; the actual list depends on the data included in your project.

## 🛠️ Built With

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI development |
| Dart | Application programming language |
| Material Design | Interface components and styling |
| Network Images | Online destination photography |
| YouTube Search | Finding travel-related videos |
| Map Links | Opening destination locations in a map app |

## 📂 Project Structure

```text
TourNest/
├── android/
├── ios/
├── assets/
│   └── screenshots/
│       ├── home.png
│       ├── search.png
│       ├── destination_details.png
│       ├── favourites.png
│       ├── travel_videos.png
│       └── booking_form.png
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   └── ...
├── test/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

> The structure above is an example. Keep the actual folder and file names consistent with your project.

## 🚀 Getting Started

Follow these steps to run TourNest locally.

### Prerequisites

- Flutter SDK installed
- Dart SDK (included with Flutter)
- Android Studio or VS Code
- Android emulator or a physical device
- Internet connection for online images and video searches

### 1. Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with your actual GitHub repository URL.

### 2. Open the Project

```bash
cd TourNest
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Format the Code

```bash
dart format lib
```

### 5. Analyze the Project

```bash
flutter analyze
```

Resolve any relevant errors reported by the analyzer before releasing the application.

### 6. Run the App

```bash
flutter run
```

## 📦 Build an Android Release

To generate a release APK:

```bash
flutter build apk --release
```

The APK will normally be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

To build an Android App Bundle for Google Play:

```bash
flutter build appbundle --release
```

Review application permissions, test on physical devices, and configure signing before publishing.

## 🖼️ Adding Screenshots to GitHub

1. Open your TourNest project folder.
2. Create `assets/screenshots/` if it does not already exist.
3. Capture screenshots of the actual running application.
4. Save the images using the filenames referenced in the gallery above.
5. Open `README.md` and verify that every image path matches the real filename.
6. Commit and push the changes to GitHub.

Example:

```bash
git add README.md assets/screenshots/
git commit -m "docs: add TourNest app screenshots"
git push origin main
```

If your default branch is not named `main`, replace it with the correct branch name.

## ⚠️ Important Notes

- **Internet connection:** Online destination images and YouTube search links require internet access.
- **Video playback:** Video entries open YouTube search results; they do not provide embedded in-app playback.
- **Booking functionality:** The trip request form is a UI demonstration. It does not create a real booking or process payments.
- **Travel information:** Destination costs and seasonal details are estimates and should be verified before travelling.
- **Production readiness:** Real reservations require a trusted provider API or backend, along with appropriate validation and secure data handling.
- **Screenshots:** The images shown in the README must be uploaded to the repository for GitHub to display them.

## 🔮 Future Improvements

- 🔐 User authentication and profiles
- ☁️ Cloud-based destination data
- 🧭 Interactive maps and navigation
- 🏨 Hotel and transport booking integration
- 💳 Secure payment integration
- 🌦️ Weather information for destinations
- 📥 Offline destination guides
- 🌐 Bengali and English language support

## 🤝 Contributing

Contributions, bug reports, and feature suggestions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push your branch.
5. Open a pull request.

## 📄 License

Choose a license before distributing the project publicly. For example, you may use the MIT License by adding a `LICENSE` file containing its terms.

---

<p align="center">
  <b>Made with ❤️ using Flutter</b>
  <br>
  Explore Bangladesh. Discover your next adventure. 🌍🇧🇩
</p>

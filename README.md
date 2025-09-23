# Namer App

A Flutter application that generates random English word pairs, allows users to **favorite**, **delete**, **undo delete**, **share**, and **copy** them. The app also includes **light/dark theme switching** and supports multiple favorite management features.

---

## ✨ Features

* **Random Word Pair Generator**

  * Tap **Next** to get a new random word pair.

* **Favorites Management**

  * Save a word pair to favorites.
  * View all your favorite word pairs in one place.
  * Delete single or multiple favorites.
  * **Undo delete** support for both single and multiple deletions.

* **Theme Switching**

  * Toggle between **Light Mode** and **Dark Mode** from the app bar.

* **Clipboard & Sharing**

  * Copy a favorite word pair to the clipboard.
  * Share a word pair with others using the system share dialog.

* **Navigation**

  * Uses **NavigationRail** for switching between *Home* and *Favorites*.

---

## 🛠️ Tech Stack

* [Flutter](https://flutter.dev/) (UI framework)
* [Provider](https://pub.dev/packages/provider) (state management)
* [english\_words](https://pub.dev/packages/english_words) (word pair generator)
* [share\_plus](https://pub.dev/packages/share_plus) (sharing functionality)

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK installed ([Install Guide](https://docs.flutter.dev/get-started/install))
* VS Code with Flutter & Dart plugins

### Installation

1. Clone this repository:

   ```bash
   git clone <https://github.com/prem-create/NamerApp.git>
   cd namer_app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
lib/
 ├── main.dart          # App entry point
 ├── MyAppState         # Handles theme, favorites, word generation
 ├── MyHomePage         # Main UI with navigation
 ├── GeneratorPage      # Word pair generator & like/next buttons
 ├── FavoritesPage      # Manage favorite word pairs
 ├── BigCard            # Displays word pairs in styled cards
 └── CopyToClipboard    # Utility for copying text
```

---

## 📌 Notes

* Uses **SnackBars** for undo, delete, and clipboard notifications.
* Multiple delete uses selection mode (long press to activate).
* Semantic labels are added for accessibility, though narrator behavior may vary.

---

## 🔗 Media

For **screenshots and demo video**, please check my LinkedIn post:
👉 [My LinkedIn Post]( https://www.linkedin.com/posts/prem-dilliwar-40425a376_flutter-dart-mobileapp-activity-7376217457361055744-x73j?utm_source=share&utm_medium=member_desktop&rcm=ACoAAFzxEsQB3u70Z-BsifOb_mxW0jmn_SuI8cE )

---

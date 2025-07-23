# 🎬 Browse Movie App

A Flutter application that allows users to search and explore movies using the [OMDb API](https://www.omdbapi.com/). Built as part of a technical assignment.

## ✨ Features

- 🔍 Search for movies by title
- 🧠 Smart caching of last search results using `SharedPreferences`
- 🖼️ Clean, responsive UI with shimmer loading placeholders
- 🧭 Smooth navigation to detailed movie screens
- 🧱 State management with `flutter_riverpod`
- 🎯 Optimized for Android (tested on arm64 release)

## 📦 Dependencies

- [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- [`shimmer`](https://pub.dev/packages/shimmer)
- [`http`](https://pub.dev/packages/http)

## 🛠️ Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/harshalpatil1117/Browse-movie-app.git
   cd Browse-movie-app

2. Get packages:
   flutter pub get

3. Add your OMDb API key in main.dart:
   const apiKey = 'YOUR_API_KEY';

4. Run the app:
   flutter run

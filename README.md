# ⚖️ Indian Law Q&A App (Frontend)

A cross-platform Flutter app that allows users to ask questions related to Indian criminal law. The app sends queries to a backend API, which returns AI-generated legal answers based on the **Bharatiya Nyaya Sanhita (BNS)**.

---

## 📱 Features

- 💬 Ask legal questions in natural language
- 🔗 Communicates with a Python Flask backend
- 📄 Displays the relevant legal section and AI-generated answer
- 🌐 Cross-platform (Android, iOS, Web, Desktop)

---

## 🧰 Tech Stack

- Flutter 3.x (Dart)
- `http` for REST API calls
- `provider` or `setState` for state management (depending on your code)
- Backend powered by Flask, Hugging Face, and Groq API

---

## 📂 Project Structure

law_frontend/
├── lib/
│ ├── main.dart # Entry point
│ ├── screens/ # UI Screens
│ └── services/ # API calls
├── assets/ # Images or static files
├── pubspec.yaml # Flutter dependencies
├── android/ / ios/ / web/ # Platform-specific code
└── README.md

---

## 🚀 Getting Started

### 1. Clone the repo
git clone https://github.com/AnkitKumarIISERB/law_frontend.git
cd law_frontend

### 2. Install dependencies
flutter pub get

### 3. Run the app
flutter run

💡 You can also run it in Android Studio, VS Code, or your preferred IDE.

---

## 🌐 Connecting to Backend

Make sure the backend Flask API is running (locally or deployed).

Update the API endpoint in your frontend code (typically in services/api.dart or similar):
final String baseUrl = "http://<your-backend-url>:5000";

If you're testing locally with Android emulator, use:
final String baseUrl = "http://10.0.2.2:5000";  // For Android emulator

---

## 🔗 Related Repository

👉 Backend (Flask + AI)

---

## 📜 License

This project is licensed under the MIT License.

---

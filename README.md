# SkillBridge - Job Support App

A comprehensive Flutter application that bridges the gap between skills and opportunities, connecting talented individuals with meaningful projects and career growth.

## 🚀 Features

### User Features
- **Google Authentication** - Secure sign-in with Google
- **Profile Management** - Complete profile with skills, education, and experience
- **Skill-based Quizzes** - Dynamic quizzes to test and improve skills
- **Project Discovery** - Browse and apply to relevant projects
- **Pitch Submissions** - Submit detailed project proposals
- **Real-time Chat** - Community chat with admins and peers
- **Progress Tracking** - Monitor quiz scores and submission analytics
- **Course Catalog** - Access learning resources and certifications

### Admin Features
- **Project Management** - Create and manage project listings
- **Pitch Review** - Review and evaluate user submissions
- **User Analytics** - Track user engagement and performance
- **Chat Moderation** - Manage community discussions

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication (Google Sign-in)
  - Firestore Database
  - Cloud Storage
  - Cloud Functions
- **State Management**: Provider/Riverpod
- **UI/UX**: Material Design 3 with custom theming

## 📱 Screenshots

[Add screenshots here]

## 🔧 Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase CLI
- Android Studio / VS Code
- Git

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/skillbridge.git
   cd skillbridge
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Google provider)
   - Enable Firestore Database
   - Enable Cloud Storage
   - Download and add configuration files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── auth/                 # Authentication services
├── data/                 # Sample data and models
├── models/              # Data models
├── screens/             # UI screens
├── services/            # Business logic and API services
├── widgets/             # Reusable UI components
└── main.dart           # App entry point

functions/              # Firebase Cloud Functions
├── index.js           # Main functions file
└── package.json       # Node.js dependencies
```

## 🔥 Firebase Configuration

### Firestore Collections
- `users` - User profiles and data
- `projects` - Project listings
- `pitches` - User submissions
- `chat` - Chat messages
- `quizzes` - Quiz data and results

### Security Rules
```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects are readable by all authenticated users
    match /projects/{projectId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.token.email == 'admin@example.com';
    }
    
    // Chat messages
    match /chat/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🎨 UI/UX Design

The app follows Material Design 3 principles with:
- **Modern gradient backgrounds**
- **Smooth animations and transitions**
- **Consistent color scheme** (Primary: #6366F1, Secondary: #8B5CF6)
- **Responsive layouts** for all screen sizes
- **Accessibility features** and proper contrast ratios

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🚀 Deployment

### Firebase Hosting (Web)
```bash
flutter build web
firebase deploy --only hosting
```

### Google Play Store (Android)
1. Build release APK/AAB
2. Upload to Google Play Console
3. Follow store guidelines

### App Store (iOS)
1. Build for iOS
2. Upload via Xcode or Transporter
3. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: [Your Name]
- **Designer**: [Designer Name]
- **Project Manager**: [PM Name]

## 📞 Support

For support, email support@skillbridge.com or join our Slack channel.

## 🔮 Roadmap

- [ ] AI-powered skill matching
- [ ] Video interview integration
- [ ] Advanced analytics dashboard
- [ ] Mobile app optimization
- [ ] Multi-language support
- [ ] Payment integration
- [ ] Certification system

---

**Made with ❤️ using Flutter and Firebase**
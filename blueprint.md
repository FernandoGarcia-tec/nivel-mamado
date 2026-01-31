# Blueprint: Nivel:Mamado

## **Project Overview**

"Nivel:Mamado" is a gamified workout tracker for Flutter, designed to feel like the "System Interface" from the anime *Solo Leveling*, but localized with Mexican Gym Slang. It leverages Firebase for backend services.

## **Style, Design, and Features**

### **Phase 1: Foundation (Current)**

*   **Visual Style:**
    *   Ultra-Dark Mode (Pure Black #000000 background).
    *   Primary Color: Neon Indigo (#6366f1) and Glowing Purple (#a855f7).
    *   Success Color: Emerald Green (#10b981).
    *   Font: 'Inter' or 'Roboto'. Monospace for numbers.
*   **Technical Stack:**
    *   **Framework:** Flutter
    *   **Backend:** Firebase Firestore & Firebase Auth
    *   **State Management:** Riverpod
    *   **Dependencies:**
        *   `firebase_core`, `cloud_firestore`, `firebase_auth`
        *   `flutter_riverpod`
        *   `fl_chart`
        *   `flutter_local_notifications`
        *   `font_awesome_flutter`, `lucide_flutter`
        *   `google_fonts`
        *   `freezed` for data models.
*   **Core Data Models:**
    *   `UserData`: Represents the user's profile and game-related stats (level, XP).
    *   `WorkoutHistory`: A record of a completed workout session.
    *   `Exercise`: Represents a single exercise within a workout.
    *   `ExerciseSet`: A single set of an exercise (reps, weight).
    *   `Routine`: A predefined template for a workout.
*   **Services:**
    *   `FirestoreService`: A dedicated class to handle all communication with the Firebase Firestore database, abstracting data fetching and saving operations.

## **Current Plan: Part 1 - Setup & Models**

1.  **Configure `pubspec.yaml`:** Add all necessary dependencies for Firebase, state management, UI, and data modeling.
2.  **Create Data Models (`lib/models.dart`):** Define the core data structures (`UserData`, `WorkoutHistory`, `Exercise`, `ExerciseSet`, `Routine`) using the `freezed` package for robust, immutable classes.
3.  **Implement Firestore Service (`lib/services/firestore_service.dart`):** Create a service class with methods to interact with Firestore for CRUD operations on user data, workout history, and routines.
4.  **Run Code Generation:** Execute `build_runner` to generate the necessary `*.freezed.dart` and `*.g.dart` files for the data models.
5.  **Enable Firebase:** Configure the project to connect with Firebase services.

📱 WalkWise – Part A
Mobile Application Design & Development – SE4041 (Part A)
BSc (Hons) in Information Technology – 2025
Overview

WalkWise is an iPhone-exclusive health companion application designed to encourage users to build and maintain a consistent walking habit. Developed entirely with SwiftUI, the app incorporates several modern iOS technologies including HealthKit, Core ML, Core Data, and secure authentication frameworks. The primary goal of WalkWise is to help users monitor daily movement, understand their physical activity patterns, and plan personalized walking sessions through an elegant and intuitive interface. The application combines motivational design elements with intelligent analytics, making it both visually appealing and functionally robust.

Purpose & Motivation

The purpose of WalkWise is to support individuals in improving their daily walking behavior using accurate health data and meaningful insights. Walking is a highly accessible form of exercise, yet many people struggle to maintain consistency due to lack of awareness or motivation. WalkWise provides a structured and visually engaging experience that motivates users through progress visualizations, tailored walking routines, and machine-learning-driven insights. The app helps users understand whether they are on track to meet their daily goals and offers a personalized dashboard summarizing walking metrics retrieved directly from HealthKit.

Target Audience

WalkWise is designed for students, working professionals, and health-conscious individuals who want a simple, non-intrusive way to track their daily physical activity. The app is particularly suitable for users who spend long hours sitting at desks, as well as for anyone seeking a motivating companion to increase their step count over time. By offering clean visuals and easy-to-read metrics, WalkWise provides an inclusive experience that appeals to users across different age groups and activity levels.

Core Functionality

WalkWise begins by presenting a soft gradient splash screen containing a motivational health tip that changes every time the user opens the app. This splash screen not only enhances the onboarding experience but also allows the application to initialize HealthKit permissions, load the user profile, and retrieve daily summaries in the background.

Once authenticated through either Sign in with Apple or Google Sign-In (Gmail), the user is presented with the main dashboard. The dashboard is built around smooth pastel gradients and displays the user’s step count, walking distance, and active walking minutes for the current day. A circular progress ring visually represents progress toward the daily step goal. Below this, machine learning insights are displayed, offering predictions such as whether the user is “On Track,” “Above Average,” or “Below Usual,” based on recent seven-day activity patterns.

The Home Dashboard also features graphical representations of activity trends. These include a seven-day step bar chart and a walking time line graph, both constructed using SwiftUI. The interface automatically updates when new HealthKit data becomes available.

In addition to analytics, WalkWise supports full CRUD functionality for custom walk sessions. Users can create personalized walking routines by specifying target duration, distance, and preferred time of day. These sessions can be viewed, edited, and deleted from the Sessions tab. All session-related data is stored in Core Data to ensure long-term persistence.

The History tab allows users to review their past walking performance. Each day is summarized with key metrics and classified using the ML model. Selecting a day opens a detailed view with richer statistics and visualizations. This historical perspective helps users evaluate progress and recognize patterns in their behavior over time.

The Profile tab provides additional personalization features. Users may change their profile picture, update their display name, modify daily step goals, and choose between kilometers and miles. The profile screen also includes options to log out or delete the account, integrating authentication management directly into the user interface.

UI/UX Design Approach

WalkWise features a modern, health-oriented design language composed of soft teal, mint, and blue gradients. These gradients are complemented by clear typography, rounded cards, and smooth transition animations. The interface emphasizes clarity and calmness, reflecting the health and wellness focus of the application. The design is fully responsive and supports both Light and Dark Mode. Accessibility has been considered throughout the development process, ensuring buttons, text, and cards are readable and interactable for all users.

Technical Implementation

WalkWise is built using SwiftUI, which powers all screens, animations, and transitions. HealthKit is used to retrieve daily step counts, walking distance, and active time. The application makes structured queries to fetch real-time and historical data. Core ML is used to classify daily activity trends. By analyzing historical walking patterns, the ML logic provides predictive insights that enhance user motivation.

Persistent storage is handled by Core Data, which stores sessions, daily summaries, and user profile data. Each Core Data entity — including UserProfile, WalkSession, and DailySummary — is designed to maintain low overhead while offering reliable long-term data retention. Authentication is handled using Sign in with Apple and Google Sign-In to ensure secure access without storing passwords locally.

A modular MVVM architecture separates responsibilities across ViewModels, services, and views. Components such as HealthKitManager, MLInsightsManager, SessionViewModel, and ProfileViewModel organize the application logic. This ensures high cohesion and ease of maintenance, making the codebase scalable and ready for extension.

Testing & Optimization

Testing efforts included unit tests for ML prediction logic and step-goal calculation, as well as CRUD operations for walk sessions. Additional UI tests verify navigation paths, login flows, and data persistence behaviors. WalkWise also underwent manual testing on different devices and iOS versions to ensure consistency, proper rendering, and responsiveness. Performance optimizations include caching health data when necessary, using efficient HealthKit queries, and minimizing expensive re-renders with optimized SwiftUI state management.

Innovation and Creativity

WalkWise introduces a unique combination of motivational design, ML-based predictions, and HealthKit-driven insights within a single seamless user experience. By blending soft gradients, personalized dashboards, detailed analytics, and flexible walk session planning, it elevates a standard health tracker into an intelligent and inviting wellness companion. The ML prediction system enhances the user’s understanding of their behavior, while the smooth login flow and profile personalization contribute to a polished and modern application design.

Conclusion

WalkWise successfully fulfills the requirements of Part A by delivering a fully functional, multi-screen, data-driven mobile application that incorporates advanced UI, HealthKit integration, secure authentication, Core ML insights, persistent storage, and an immersive user interface. The application demonstrates strong technical understanding, thoughtful design decisions, and a clean architectural structure suitable for real-world use.

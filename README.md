# Recipe Finder & Meal Planner

This Flutter app allows users to discover recipes based on available ingredients, view detailed recipes, save favorite recipes, and plan meals for the week. The app integrates with the Spoonacular API.

## Functional Requirements

- **API Integration**
    - Recipes are fetched using the Spoonacular API.

- **Recipe Search**
    - Users can search recipes by entering ingredients they have at home.

- **Recipe Details**
    - Shows ingredients, recipe image and nutritional info (if available).

- **Favorites**
    - Users can save and manage favorite recipes.

- **Meal Planning**
    - Weekly meal plan feature using saved recipes.

- **Local Storage**
    - Favorite recipes and meal plans are stored locally using Hive.

- **Offline Mode**
    - Users can access saved recipes and plans without an internet connection.

- **Caching**
    - API responses are cached per keyword with a 30-minute expiration.

## UI Overview

- **Search Screen**
    - Input field for ingredients search.

- **Recipe List**
    - Scrollable list/grid showing recipe thumbnails, titles, and short descriptions.

- **Recipe Detail Screen**
    - Detailed recipe view with ingredients, steps, and image.

- **Favorites & Meal Plan**
    - Tabbed interface for viewing and managing saved recipes and weekly meal plans.

## Tech Stack

- **Language:** Dart 3.7.0
- **Framework:** Flutter 3.29.0
- **State Management:** Bloc
- **API:** Spoonacular API
- **Local Storage:** Hive
- **Offline Support:** Local DB fallback
- **Caching:** In-memory and/or local DB with time-based refresh logic

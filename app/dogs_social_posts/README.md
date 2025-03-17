# Social Media Dog Post Creator

This repository contains two main components:

1. **Flutter App**: A mobile application for creating, managing, and scheduling social media posts for dogs.
2. **Node.js API**: A backend API for managing posts, including CRUD operations.

---

## Flutter App

### Features

- **Create Posts**: Add messages, hashtags, and images to your posts.
- **Edit Posts**: Modify existing posts, including their messages and hashtags.
- **Schedule Posts**: Set a specific date and time for posts to be published.
- **Delete Posts**: Remove posts that are no longer needed.
- **Responsive Design**: Optimized for both mobile and tablet devices.

### Getting Started

#### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.

#### Installation

1. Navigate to the Flutter app directory:
   ```bash
   cd app/dogs_social_posts
   
2. Install dependencies:
    ```bash
    flutter pub get
    
3. Run the app:
    ```bash
    flutter run
    
#### Configuration

The app uses a centralized configuration file located at `lib/src/config/config.dart`. Update the following constants as needed:
    
    ```
    class Config {
        static const String apiBaseUrl = 'http://localhost:3000'; // Base URL for the backend API
        static const String defaultAvatarUrl = 'http://localhost:3000/images/default_avatar.png'; // Default avatar image
    }


## Node.js API

### Features

- CRUD Operations: Create, read, update, and delete posts.
- RESTful Endpoints: Exposes endpoints for managing posts.
- Data Storage: Uses an in-memory database or can be configured to use a persistent database.

### Getting Started

#### Prerequisites

- Node.js installed on your machine.
- npm or yarn for dependency management.

#### Installation
1. Navigate to the Node.js API directory:

    ```bash
    cd api

2. Install dependencies:

    ```bash
    npm install
    
3. Start the server:

    ```bash
    npm start

4. The API will be available at `http://localhost:3000`.

### API Endpoints

| Method | Endpoint          | Description               |
|--------|-------------------|---------------------------|
| GET    | `/posts`          | Fetch all posts           |
| GET    | `/posts/:id`      | Fetch a single post       |
| POST   | `/posts`          | Create a new post         |
| PUT    | `/posts/:id`      | Update an existing post   |
| DELETE | `/posts/:id`      | Delete a post             |

---

## Folder Structure

- `app/dogs_social_posts`: Contains the Flutter app.
- `api`: Contains the Node.js API.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes and push them to your fork.
4. Submit a pull request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Acknowledgments

- [Flutter Documentation](https://flutter.dev/docs)
- [Node.js Documentation](https://nodejs.org/en/docs/)
- [Internationalizing Flutter Apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)






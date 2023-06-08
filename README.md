# Ozim-Platform

<p align="center"><a href="http://ozimplatform.com" target="_blank"><img src="https://static.tildacdn.com/tild6430-6563-4830-b538-363264643761/logo.svg" width="400"></a></p>

## About Ozim Platform

Ozim Platform is a mobile app for parents of early-age children. It provides information on early development and intervention in both text and video formats. We bring together researchers in the fields of education and inclusion, as well as specialists in early intervention, to help parents cultivate their children's skills at home.

## Learning Ozim Platform

Ozim Platform mobile app has the most useful information on children's development, including the development of children with special needs. To download the app, please visit the [Ozim Platform page](http://ozimplatform.com/en/?utm=en) on the App Store or Google Play.

We also have information about our other projects and events [here](http://ozimplatform.com/en/?utm=en).

## Installation and Deployment Guide

### Requirements

#### Frontend
* [Android Studio 3.5.3](https://developer.android.com/studio)
* [Android Minimal SDK 21](https://developer.android.com/studio/releases/platforms)
* [Android Targeted SDK 31](https://developer.android.com/studio/releases/platforms)
* [Java 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

#### Backend
* [PHP](https://www.php.net/downloads.php)
* [Composer](https://getcomposer.org/download/)
* [Laravel](https://laravel.com/docs/8.x/installation)
* [MySQL](https://www.mysql.com/downloads/)

### Installation

#### Frontend

1. **Clone the repository**: Open a terminal and run the following command:

    ```bash
    git clone https://github.com/Ozim-Platform/Ozim-Platform.git
    ```

2. **Setup keystore**: In the root directory of the project, create a file named `keystore.properties` and add the following lines:

    ```properties
    storeFile=../keystore.jks
    storePassword=2cag84jj
    keyAlias=key
    keyPassword=2cag84jj
    ```

3. **Setup and build the project in Android Studio**: Open Android Studio and import the project from the cloned repository.

#### Backend

1. **Clone the repository**: Clone the repository using the git clone command in the terminal:

    ```bash
    git clone https://github.com/Ozim-Platform/Ozim-Platform.git
    ```

2. **Install dependencies**: Navigate into the project directory and run the following command:

    ```bash
    composer install
    ```

3. **Environment setup**: Copy the `.env.example` file and rename it to `.env`. Configure the following variables:

    ```bash
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=your_database_name
    DB_USERNAME=your_username
    DB_PASSWORD=your_password
    ```

    Generate a Laravel application key:

    ```bash
    php artisan key:generate
    ```

4. **Database migration**: To run the database migrations, run the following command:

    ```bash
    php artisan migrate
    ```

5. **Start the server**: Start the local server using the following command:

    ```bash
    php artisan serve
    ```

## Contributing

Thank you for considering contributing to the Ozim Platform! If you are interested in becoming a sponsor, please visit the [Ozim Platform](http://ozimplatform.com/en/?utm=en).

## Code of Conduct

In order to ensure that the Ozim Platform community is welcoming to all, please abide by the Code of Conduct: Be tolerant of opposing views, and ensure that your language and actions are free of personal attacks.

## Privacy Policy

The Privacy policy of the mobile app Ozim Platform is available at [Privacy Policy](https://github.com/Ozim-Platform/Ozim-Platform/blob/7167ea40f2ed16e60a9ca76271ccbbb941485488/documents/Ozim%20Platform%20PrivacyPolicy.pdf).

## Security Vulnerabilities

If you discover a security vulnerability within Ozim Platform, please send an e-mail to Assem Tazhiyeva via [ozim.project@gmail.com](mailto:ozim.project@gmail.com). All security vulnerabilities will be promptly addressed.

## License

The Ozim Platform framework is open-sourced software licensed under the [BSD 3-Clause](https://github.com/flutter/flutter/blob/master/LICENSE).

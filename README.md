# Korba Flutter Test

This ReadMe file contains the instructions for building the Korba Flutter Test application for android.

## Tools needed to run this project

* Android Studio, VS Code, IntelliJ IDEA
* Flutter SDK (version 2.10.1 was used in this project)
* The Project is build with null-safety support
* It may be run on a physical device or emulator

## Create a debug build

* Open the project in any of the IDEs listed above

```
flutter run
```

## Create a release build

* Open the project in any of the IDEs listed above

```
flutter build apk
```

# Project structure

The main code of the project are located in the lib fold

The lib contains the main.dart file and two other folders (core, features)

The core folder contains strings and other utility call that will be need throughout the app

The features folder contains main functionilities of the app grouped in related sub-folders 

Each feature (in this case account and users) has it's own model, view and controller folders

# Challenges

Noticed the api token wasn't very consistent. At one point, all tokens generated after sign up couldn't be use to access the api endpoint.

All api calls resulted in "Invid Token".

The challenge persisted when testing with Postman and within the app.

Tokens generated after login however works fine


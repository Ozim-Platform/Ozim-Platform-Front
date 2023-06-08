# Newborn Nutrition Reference App

An android reference application that leverages Google's FHIR Android SDK and WHO's Neo-natal Digital Adaptation Kit (NNDAK) to build a standard's based mobile solution to link Newborn Units and Human Milk Banks.

## Getting Started 
You are welcome to use the app as is, or you can build it from source.The app is built using Android Studio and the latest version of the Android SDK.
* [Android Studio 3.5.3](https://developer.android.com/studio)
* [Android SDK 29](https://developer.android.com/studio/releases/platforms)
* [Java 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [FHIR Android SDK 0.5.0](https://github.com/google/android-fhir)

### Installing and Setting
Ensure you have android studio installed on your machine.

Clone the repository below

```
git clone https://github.com/IntelliSOFT-Consulting/human-milk-bank.git
```

Open the project in android studio and sync the dependencies.

## FHIR Server Configuration
The app is configured to use the [HAPI FHIR Server](https://hapifhir.io/) as the FHIR server. You can use any FHIR server of your choice. To configure the app to use your FHIR server, you will need to change the following.
```
Base URL of the FHIR server
```
You can locate this in this [Server Configuration](https://github.com/IntelliSOFT-Consulting/human-milk-bank/blob/main/app/src/main/java/com/intellisoft/nndak/FhirApplication.kt) file path


## Deployment
To create a release build, you will need to create a keystore and add it to the project. You can follow the instructions [here](https://developer.android.com/studio/publish/app-signing#generate-key) to create a keystore. 

Once you have created the keystore, add the keystore file to the project and update the following in the [gradle.properties]()
```
storeFile=keystore.jks
storePassword=your_keystore_password
keyAlias=your_key_alias
keyPassword=your_key_password
```

To create a release build, run the following command in the terminal
```
./gradlew assembleRelease
```
## Security & Privacy 
We do not collect or share any personal or sensitive user data with any third party libraries or SDKs. You can access a copy of the privacy policy [here](https://github.com/IntelliSOFT-Consulting/Newborn-Nutrition-Reference-App/blob/main/privacy-policy.pdf)
## Built With
* [Android Studio](https://developer.android.com/studio) - The IDE used
* [Gradle](https://gradle.org/) - Dependency Management
  
## Acknowledgments 
* [FHIR Android SDK](https://github.com/google/android-fhir) - The FHIR SDK used to build the app


## License
[![License](http://img.shields.io/:license-gnu-blue.svg?style=flat-square)](http://badges.gnu-license.org) 

Licensed under the GNU General Public License, Version 3.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://github.com/IntelliSOFT-Consulting/human-milk-bank/blob/main/LICENSE.md

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


 

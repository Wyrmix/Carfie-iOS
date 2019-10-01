# Carfie iOS
This is the combined monorepo for the Carfie iOS Rider and Driver apps. It provided code sharing between the app targets and one project/workspace to generate Pods against.

## Dependencies
### [Cocoapods](https://cocoapods.org/)
Dependency management. If you don't know what this is you haven't been doing iOS development.
### [XcodeGen](https://github.com/yonaskolb/XcodeGen)
Xcodegen is an open source tool for programatically creating Xcode project files. It uses yml to create the configurations and can be built from the command line. No more project file conflicts!

## Building the Project
All dependencies and configurations are documented in code, so this is pretty simple.
1) Be sure you have installed the above dependencies
2) Before opening Xcode run the following from the command line:
    ```
    xcodegen generate
    pod install
    xed .
    ```
3) You should now have an open Xcode workspace witha  building project

fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Build and run all tests
### ios core_tests
```
fastlane ios core_tests
```
Build and run Core tests
### ios rider_tests
```
fastlane ios rider_tests
```
Build and run Rider tests
### ios driver_tests
```
fastlane ios driver_tests
```
Build and run Driver tests
### ios beta
```
fastlane ios beta
```
Build and deploy all app targets
### ios beta_rider
```
fastlane ios beta_rider
```
Build and deploy Rider to TestFlight
### ios beta_driver
```
fastlane ios beta_driver
```
Build and deploy Driver to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

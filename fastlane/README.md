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
### ios certificates
```
fastlane ios certificates
```
Certs
### ios ci_build
```
fastlane ios ci_build
```
CI build
### ios circleci
```
fastlane ios circleci
```
Circle CI lane
### ios travis
```
fastlane ios travis
```
Travis lane
### ios release
```
fastlane ios release
```

### ios dsyms
```
fastlane ios dsyms
```
Download dSYMs and upload to Testflight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

# iMAS Sentry Application[![analytics](http://www.google-analytics.com/collect?v=1&t=pageview&_s=1&dl=https%3A%2F%2Fgithub.com%2Fproject-imas%2Fsentry-app&_u=MAC~&cid=1757014354.1393964045&tid=UA-38868530-1)]()

## Background

The "iMAS Sentry App" provides a simple way to include several of the iMAS security controls on your device.  The sentry app provides this protection without requiring modifications to existing applications.  It supports communication with external servers, such as the [https://github.com/project-imas/mdm-server](open-source iMAS MDM server), to automatically report and react to known threats.  The level and types of protection are entirely configurable through a GUI system, allowing for simple setup and usage.

The sentry combines the following capabilities into one deployable package: 
 * [Jailbreak and debugger detection](https://github.com/project-imas/security-check)
 * [Network and Process monitoring](https://github.com/project-imas/system-monitor)
 * [Device passcode checking](https://github.com/project-imas/passcode-check)
 * [MDM server integration](https://github.com/project-imas/mdm-server)
 * [Single-sign-on capabilities](https://github.com/project-imas/single-sign-on)
 * Geo-fencing of allowed device regions

## Installation via CocoaPod

After downloading the repo, start by inititalizing the cocoapods.  If you have not installed cocoapods yet, see the [cocoapods installation guide](http://guides.cocoapods.org/using/getting-started.html) for instructions.  After cocoapods has been installed, simply run the following command while in the project directory:

    pod install

This should install all pods needed for the project.  Then open the sentry-app.xcworkspace file (instead of the .xcodeproj file) to work on the app.

In order to pair your app with the sentry app's single-sign-on capability, see the [single-sign-on readme](https://github.com/project-imas/single-sign-on) for instructions.

In order to create a customized passcode policy, see the [passcode-check readme](https://github.com/project-imas/passcode-check) for the instructions.

The sentry-app contains code that is not available to iOS simulators, and can not be run on the "iPhone Simulator".  It must be run directly on a real device instead.

## License

Copyright 2014 The MITRE Corporation, All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

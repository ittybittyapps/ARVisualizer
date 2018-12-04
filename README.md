# <img src="icon@2x.png" alt="AR Visualizer icon" width="32" height="32"> AR Visualizer

This project is a prototype of a real-time visualization tool for ARKit sessions. It consists of:

- An iOS app that runs the ARKit session and acts as a server.
- iPad and macOS client apps that receive the live session data and render the virtual scene.

Visualized information includes:

- Basic frame/camera stats.
- Camera position/orientation in the virtual space.
- Scene feature points: either current frame or accumulated, with image-based color sampling.
- Scene plane anchors: extents or geometry.
- Custom anchor positions.

## How to build

1. Clone the repository and open `ARVisualizer.xcworkspace` in Xcode 10 or newer.
2. Configure automatic codesigning for `Server` and `MobileClient` projects/targets by opening their target settings, _General_ tab, and configuring the _Team_ setting in the _Signing_ section.
3. Build and run `MobileClient` scheme on a supported iPad device _and/or_ `DesktopClient` scheme on the Mac.
4. Build and run `Server` scheme on a supported iPhone or iPad device.

## How to use

Client apps start in an idle state, waiting for a server to start, and connect to it automatically once it appears. When the server app launches, it starts an ARKit session automatically, advertises its presence over Bonjour, and starts streaming live session data to the connected clients. Multiple clients can simultaneously visualize the same live ARKit session.

> **Note:** If you're having connectivity issues, try restarting both the server and the clients. If necessary, connect the devices running them to the same Wi-Fi network.

Client apps allow customizing visibility of the feature points and the plane anchors, and also provide several camera modes:

- _First Person_: camera reflects the AR camera view directly.
- _Third Person_: camera appears behind the AR camera, still tracking its position and orientation.
- _Top-Down_: camera appears above the AR camera, tracking its position but always pointing down.
- _Turntable_: camera can be controlled independently from the AR camera, orbiting around a point.
    - On an iPad, use one-finger panning to rotate, two-finger panning to move around, two-finger pinch to zoom, and three-finger panning to move forwards/backwards.
    - On a Mac, click and drag to rotate, scroll to move around, and ⌥-scroll or pinch on the trackpad to forwards/backwards.
- _Fly_: camera is free-floating and can be controlled independently from the AR camera.
    - On an iPad, use one-finger panning to look around, two-finger panning to move up/down/left/right, and three-finger panning to move forwards/backwards.
    - On a Mac, click and drag to look around, scroll to move up/down/left/right, and ⌥-scroll or pinch on the trackpad to move forwards/backwards. W/S/A/D keys can also be used to move forwards/backwards/left/right.

## Supported devices

Server app supports iOS 11.0+ devices with A9 chip or newer. This includes:

- iPhone SE
- iPhone 6S, 6S Plus or newer
- iPad (2017, 5th generation) or newer

Mobile client app supports iPad devices running iOS 11 or newer.

Desktop client app supports Macs released in or after 2012, running macOS 10.13 or newer.

## See also

[AR Recorder](https://github.com/ittybittyapps/ARRecorder): an example of using ARKit's private SPI to record and replay session sensor data.

## Licensing

This work is licensed under a <a rel="license" href="https://opensource.org/licenses/BSD-3-Clause">BSD 3-Clause License</a>.

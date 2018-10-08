# Face Finder plugin

A flutter plugin to display a live camera view, detect faces, and HTTP POST them to a URL.

## Requirements

* iOS only (all PRs accepted)
* Front camera: iPhone X or later
* Back camera: iOS v11+

## Usage

The following draws a camera view overtop of all layers in the app, with the following configuration:
* Position: [0, 0, 200, 400] = [x, y, width, height]
* URL: [https://www.example.com/upload](https://www.example.com/upload) to HTTP POST any faces to (1 per second)

```dart
import 'package:face_finder/face_finder.dart';
...
await FaceFinder.cameraViewer(
	[0, 0, 200, 400], 
	"https://www.example.com/upload"
	);
````

## Notes
This is mainly a proof of concept at this point, but I'm submitting it in case it's useful to someone. I couldn't find any example of Swift Flutter plugins that used UIViews, so I thought the code might be helpful for others. If anyone knows how to use textures in Swift, let me know ;)
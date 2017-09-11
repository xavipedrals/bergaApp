# BergApp
This is an app made for the people of my home town Berga, Barcelona province in Spain. The app intention was to gather the relevant news headings about local newspapers, get the events of the town and near villages in a calendar and displaying shops info in a beautiful way.

The app was designed and implemented by me, you have a Sketch file containing the design. The design was based on Apple iOS 11 design.
https://www.sketchapp.com

## Technology involved
This app was implemented in Swift using MVVM pattern + RxSwift.

## App structure
Note that the app language is Catalan, the official language in Catalonia, Spain.

### News
Here you can see the news of the local newspapers, you can share them or tap them to go to the newspaper website.
<p align="center">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0509.jpg" width="32%" margin="auto">
</p>

### Calendar
Here you can see the near events, their date and their basic info.
<p align="center">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0510.jpg" width="32%" margin="auto">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0512.jpg" width="32%" margin="auto">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0513.jpg" width="32%" margin="auto">
</p>

### Shops
Here you can see the shops of the town and their info.
<p align="center">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0545.jpg" width="32%" margin="auto">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0514.jpg" width="32%" margin="auto">
<img src="https://raw.githubusercontent.com/xavipedrals/bergaApp/develop/Screenshots/IMG_0546.jpg" width="32%" margin="auto">
</p>

## How to build
This app uses Carthage so after downloading you will need to run
```sh
carthage update --platform iOS
```

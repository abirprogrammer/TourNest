# TourNest

TourNest is a Flutter starter app for exploring travel destinations in Bangladesh.

## Features
- Destination home screen inspired by the provided design
- Search by destination name, location, or category
- Category filters: All, Beach, Hills, Nature
- Destination cards with images, ratings, and favourites
- Destination detail screen with map link and travel information
- Travel video list that opens relevant YouTube search results
- Demo trip/ticket request form with name, phone, date, and traveller count
- Responsive scrolling layouts and image loading fallbacks

## Run
```bash
flutter pub get
dart format lib
flutter analyze
flutter run
```

## Important notes
- Images require an internet connection.
- The video entries open YouTube search results; they are not embedded in-app video playback.
- Booking is a UI demo only. It does not create a real reservation or take payment. Connect a trusted transport/tour provider API and backend before production use.
- Destination costs and seasonal information are estimates; verify them before travel.

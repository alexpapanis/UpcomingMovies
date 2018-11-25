# UpcomingMovies

This aim of this project is to list the upcoming movies and show their details. There is a search bar that allows the user to search for any movie in database. 

## Screenshots
![alt_tag](https://github.com/alexpapanis/UpcomingMovies/blob/development/screenshots/screenshots.png)

## Requirements
### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

## Usage
In order to correctly compile:

1. Clone the repository.
2. Go to your the project folder in command line and run:
```
$ pod install
```
3. Open the UpcomingMovies.xcworkspace file and build the project.
4. Choose a device to run the project.

## Features

* List all upcoming movies from The Movie Database webservice: https://developers.themoviedb.org/3/movies/get-upcoming
* Search for any movie by name from webservice: https://developers.themoviedb.org/3/search/search-movies
* Aftere searching, you can go back to upcoming movies taping Cancel button or searching an empty string.
* Tap on movie to see more details. On next screen you can see the poster image, the rating and its description. 
* Tap on poster image on movie detail screen to see the image in full screen mode. If you long press on the image, you are able to download the image.
* The backdrop images are downloaded and stored physically on the phone. Whenever you have an image to download, the app tries to find the image locally, otherwise the image will be downloaded. 
* The poster images are cached by SDWebImage library. 

## Libraries

### Alamofire
Alamofire is a popular dependency that manages all network communication.
In this project I used Alamofire to call The Movie Database's webservices and retrive the information.
### RxSwift and RxCocoa
They are a simple, elegant and powerful way to introduce Rx to the project. 
In this project, I use Observable to keep an eye for the moment to fetch more movies. 
### SDWebImage/WebP
This library provides an async image downloader with cache support. 
All poster images are cached with this library. 

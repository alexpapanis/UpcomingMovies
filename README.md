# UpcomingMovies

This aim of this project is to list the upcoming movies and show their details. There is a search bar that allows the user to search for any movie in database. 

## Screenshots
![alt_tag](https://github.com/alexpapanis/UpcomingMovies/blob/development/screenshots/screenshots.png)

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

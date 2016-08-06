# Names App 1.0.0

Names App is a mobile application developed with Starling Framework and FeathersUI. It showcases how to use asynchronous SQLite to perform CPU intensive queries without blocking the app's UI. It also demonstrates several useful techniques for most business apps.

It uses the following APIs and technologies:

  - Wikipedia API (XML)
  - SQLite
  - File & FileStream APIs

Some of the techniques covered are:

  - Creating and managing a file to store user favorites.
  - Material Design inspired custom theme.
  - Passing data between screens.
  - Remembering the app's state between screens.
  - Correctly disposing unused objects.
  - Multi DPI development.

To compile this application you only require AIR 22 or greater, FeathersUI 3.0.2 and Starling 2.0.1.

[![Watch on Youtube](http://i.imgur.com/epHEp9p.png)](https://www.youtube.com/watch?v=_PRBtezyM1g)

## About the Database

The included SQLite database was created using the data from the [Baby Names from Social Security Card Applications-National Level Data](http://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data), it includes about 1.8 million records from 90,000~ names.

2 tables were created, one using all the information from the data set, the other one is a subset that only contains names and total counts.

Indexes were added to both tables to increase the querying performance.

A special thanks to my colleague ['Cabrakan'](https://twitter.com/quepongoaqui) for his expertise and guidance with SQL.

## Download

You can test this app by downloading it directly from Google Play.

[![Download](http://i.imgur.com/He0deVa.png)](https://play.google.com/store/apps/details?id=air.im.phantom.names)
# Naimish_O2h_iOSTest

Gallery Wallpaper App (iOS)

A simple Gallery Wallpaper iOS application built with Swift that allows users to authenticate using Google Sign-In and browse a list of online wallpapers with pagination. The application stores the images locally so that users can continue viewing them even without an internet connection.


Features
1. Google Authentication

Users can securely log in using their Google account through Firebase Authentication with Google Sign-In.

2. Online Wallpaper Gallery

The app fetches wallpapers/images from an online source and displays them in a scrollable gallery.

3. Pagination Support

Images are loaded using pagination to improve performance and reduce memory usage when handling large datasets.

4. Offline Image Persistence

Once images are fetched from the network, they are stored locally using a database, allowing users to access them even without an internet connection.

5. Profile Page

A simple profile page that displays the user’s information such as:

Profile image
User name
Email address

The profile screen also provides options to:

Logout
Delete account
--------------------------------------------------------------
Technologies Used
Swift
UIKit
Firebase Authentication
Google Sign-In SDK
Core Data / Local Database (for offline image persistence)
REST API / JSON data source
Auto Layout

## Yelp

This is a Yelp search app using the [Yelp API](https://www.yelp.com/developers/documentation/v2/search_api).

Time spent: About 10-12 hours

### Features

#### Required

- [x] Search results page
    - [x] Table rows should be dynamic height according to the content height
    - [x] Custom cells should have the proper Auto Layout constraints
    - [x] Search bar in the navigation bar .
- [x] Filter page
    - [x] The filters table should be organized into sections as in the mock.
    - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
    - [x] Display some of the available Yelp categories (choose any 3-4 that you want).
    - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).

#### Optional
- [x] Search results page
    - [x] Infinite scroll for restaurant results
    - [x] Implement map view of restaurant results
- [x] Filter page
    - [x] Radius filter should expand as in the real Yelp app
- [x] Implement the restaurant detail page.

### Walkthrough

![Video Walkthrough](yelp.gif)

Libraries:
- AFNetworking
- JTProgressHUD
- BDBOAuth1Manager

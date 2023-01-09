#  NeighborhoodGems

### Project Description

    NeighborhoodGems is a neighborhood exploration tool for finding hidden gems and new neighborhood favorites. 
    This will be used to discover new and exciting places to visit in one’s area.
    
    When the app opens, the user will be prompted to authorize location services. 
    If authorized, the user will be shown a list of interesting nearby places based on their current location, and if unauthorized, a default location. 
    On the home page, the user can also search for places based on category (such as “Arts and Entertainment”) and a specific geocodable location. 
    The app will use the search criteria to generate a list of places.
    
    One main feature is that the app will suggest a neighborhood(s) to visit based on the results. 
    Additionally, for each place, the app will generate a map of the location and any optional tips about the location.
    
    Not only does this app help the user find places to go, but it also showcases events nearby based on a user’s location. 
    Through the help of the Ticketmaster API, a link for more information about the event will be provided and help the user make informed decisions about any potential upcoming events.

### Overview

    * This iOS app implements two features: 1) Places, and 2) Events
        * PLACES
            * API Data Source: Foursquare API
            * Controllers
                - A navigation controller
                - A main view controller displaying search fields and a list of places
                - A results view controller displaying search results and the top neighborhood(s)
                - A view controller displaying more details for each selected place
            * Relevant Data Models
                - A place is represented with:
                    - id
                    - categories
                    - distance
                    - geocodes
                    - link
                    - location
                    - name
                    - timezone
        * EVENTS:
            * API Data Source: Ticketmaster API
            * Controllers
                - A navigation controller
                - A main view controller displaying events nearby
            * Relevant Data Models
                - An event is represented with:
                    - id
                    - name
                    - url 
                    - dates

### Architectural Design

    * Code Architecture
        * This app implements the MVC design pattern.
        * To make this app scalable and extensible, the folder structure is divided into 5 main components:
            - SupportingFiles
            - APIClient
            - Models
            - Views
            - Controllers
                - Helpers
                - Core
        * The supporting files hold files central to the start, launch, and maintenance of the app.
        * The APIClient holds 3 files.
            * NGAPIService is our main API Service objecct that holds network code in getting data from the APIs and serving it to the UI.
            * NGAPIRequest holds network code that acts as a blueprint for all network requests based on REST and the HTTP protocol.
            * NGAPIEndpoints stores all the API endpoints used in the app and their configurations.
        * The app's Models folder stores all our data models. These models all conform to Decodable to simplify parsing from JSON responses.
        * The app's Views folder stores all our base view components.
        * The helper controllers include two classes: 1) NGDataHelper, and 2) NGLocationHelper
            * NGDataHelper serves the purpose of centralizing, storing, and providing the app's data to the UI when needed.
            * NGLocationHelper serves the purpose of managing the user's current location, location updates, and authorization changes.
        * The app's core controllers receive place and events data and handles communication between our models and views.

### UI & Usage of UI Components

*This app uses four screens. UIViews used includes: 
    UIView, UILabel, UIButton, UITextField, UICollectionView, MKMapView, UISwitch, UIPickerView, UIScrollView
*Clicking on a place in the CollectionView will open place details on another screen.
*On the events screen, clicking on the link will redirect the user to the event on Ticketmaster.

#### Homepage
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/1homepage.imageset/simulator_screenshot_4B7D6ADA-9EBE-458A-AF11-EDF2E680F1BA.png" width="300" />

*On the homepage, the user will be shown not only search fields, but a list of places in the category of "Community". I thought community centers will be a useful, general category to pull places from.

#### Category Search Field with Dropdown
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/2categoryDropdown.imageset/simulator_screenshot_620C5DC9-C9F3-488C-A6AF-0198FA0C06C7.png" width="300" />

*A dropdown was implemented to help the user search for valid place results.

#### City Search Field with Dropdown
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/3cityDropdown.imageset/simulator_screenshot_8F62B658-9D45-4B47-8064-462C14F316D1.png" width="300" />

*A dropdown was implemented to help the user search for valid place results.

#### Foursquare API Results w/ Top Neighborhood
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/4placeSearchResults.imageset/simulator_screenshot_4B023B09-0648-4787-AC6A-B4F039F62884.png" width="300" />

#### Place Detail with Map & Points of Interest Switch
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/5placeDetail.imageset/simulator_screenshot_45D35A90-4ECF-47BD-BB78-AA90A5F4BFC7.png" width="300" />

*I implemented a Points of Interest switch in case some places have nearby attractions. The user will have the option to display this or not.

#### Ticketmaster Events API Results with Link
<img src="https://github.com/mercybaffour/neighborhood-gems/blob/main/NeighborhoodGems/SupportingFiles/Assets.xcassets/6eventsNearby.imageset/simulator_screenshot_A851D070-BE8A-4AAC-984D-986127FDB693.png" width="300" />

### Discussion 

    * Areas to Improve & Lessons Learned
        * With more time, it will be useful to use a generic type for the type of data object we expect to get back from the API calls. 
            - This will hopefully reduce duplication in the NGAPIService call functions.
        * Error handling should probably be handled more gracefully. 
            - The app currently handles errors from the API calls by printing errors to the console and presenting relevant modals to the user. 
            - Additional logging will be useful.
        * As the project enlarged, I realized that the MVC design pattern bloated the view controllers. 
            - It will be beneficial to refactor the code to implement other design patterns, such as MVVM.
        * Memory management could be improved.
            - To make this app more performant, I will need to do additiional research on how to release memory from the various API calls and other situations to avoid memory leaks and retain cycles.
        * UIView Extensions
            - There's some duplication on the main view controllers with a lot of repeating UI code. 
            - It'll be useful to have more base, general UIView blueprints that can be reused across view controllers.
        * For a better user experience, it will be useful to incorporate skeleton screens or placeholder UIs as the user waits for content to load. 
            - Also, instead of using alerts only, I might consider using an 'empty state' call to action button when content can't be shown due to connectivity isssues or other reasons.
        * Most importantly, it'll be beneficial to design the app with features that produce relevant results. 
            - This will be a better user experience, since the user will not have to search again often. 
            - Future directions may include aggregating the results of multiple APIs instead of relying solely on the Foursquare and Ticketmaster API.
            - Also, including different categories and cities that will produce results the majority of the time will be beneficial.



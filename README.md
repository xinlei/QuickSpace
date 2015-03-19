##What it does
We have designed an app to allow people to temporarily rent out whatever spaces they have for whatever reason they choose to. For example, if you went shopping in San Francisco and wanted to keep your bags somewhere while you do other stuff in the city, you could look up a “closet” space that someone’s offering in their home (or other type of building space) and reserve it. It is essentially the uber-ization of building space rather than transportation.

##Technical specifications
###User Interface
Constraints are set to fit to the size of the page. The UI elements all stretch to fit proportionally for different screen sizes
Data is populated in a UITableView
All other items are put on a UIScrollView. All the items are created on the storyboard, and their locations are dynamically set programmatically under viewDidLoad
The scroll views are all initialized at 1000 pixels long and the width of the screen. All the UI elements are then placed in order, and the page is cropped at the placement of the last element on the scroll view

###Classes
Amenity: Enumeration of five amenity types: wifi, refrigerator, studyDesk, monitor, and services
Type: Enumeration of four listing types: rest, closet, office, and quiet.
Booking: Booking is a subclass of PFObject and belongs to a NewListing object. Each booking also belongs to a specific user
NewListing: NewListing is a subclass of PFObject and has many bookings and belongs to a specific user. It offers methods to convert amenities and types to NSString and validate the correctness of address and price user input before setting these values on the listing object. It also encapsulates querying for a NSArray of listings based on user input, such as amenity types, times, location, etc. 
###Creating a new listing process
On the first screen where we gather the basic listing information, we create a NewListing object that is passed from screen to screen in the prepareForSegue method.  On the second screen, we use  the CLGeocoder class to determine the coordinates of the address string. An error message is displayed if the address is invalid. On the next screen, we allow the user to set the amenities and price. An error message is displayed if the price is invalid. As the final step, we used UIImagePickerController to let the user have the ability to take a picture or select a picture from their photo library. At the end of the process, the user confirms the listing and the object is saved to the  database and “pinned” to local datastore. We are storing all of the listings created locally to allow for fast retrieval and editing.

###Finding a space
On the discover screen, we have pre-populated a UITableView with popular locations (Stanford, San Francisco, and Los Angeles). We add a search bar to the top to enable specific location searches. This is controlled by a UISearchDisplayController. Next, the user user is presented with a screen to set basic filtering options, such space type and start and end time. These values are stored to NSUserDefaults. Once the user taps “Next”, a UITableView with available listings are shown. The user can tap on a specific listing to bring up the listing details. If a booking is made (by tapping “Book”), we create a new Booking object, associated it with this listing, and save it to both Parse and the local datastore. Similar to creating a new listing, we save the Booking object locally to allow faster retrieval. Going back to the main list of listings, the user can also switch to the map view, where we created a customAnnotation, which is a subclass of MKAnnotation, to show individual pins with some listing information and tappable button for leading to the listing details screen. From the main lists of listing, the user can also use the advance filter screen to filter by specific amenities and price. These values are also stored to NSUserDefaults, similar to basic filtering options.

###Viewing user profile
On the user profile page, we have a UISwitch to switch between rentals and listings created by the user. Tapping a specific listing brings up UIActionSheet displaying options to remove, edit, and view current bookings. Respectively, tapping a specific booking brings up a UIActionSheet displaying rating values. If the user choose to edit their listing, then we query the database for the listing object and display its existing values. Once the “Submit Change” button is tapped, we saved the changes. Logging out clears NSUserDefaults and removes all object from the local datastore. 

###External Libraries
We used the following the external libraries to make the product more dynamic and user  friendly:
Parse: We used Parse as a backend service. The features we used are its relational database support, subclassing, local datastore, geolocation, and user.  
SVProgressHUD: The class displays a HUD to convey an ongoing task. This is used when we make queries to Parse to display listings by criterion such as amenities, types, and available times. 

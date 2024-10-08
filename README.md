# Tourist Guide App - Flutter

The goal of the app is to facilitate tourism by providing information about points of interest in various locations. These locations can range from cities to mountains, beaches, islands, and regions.

Key Features:
-Browse Locations: Users can select locations, such as cities, mountains, beaches, islands, or regions, from a list that can be sorted alphabetically or by proximity to their current location.
-View Points of Interest: After selecting a location, users can view and sort points of interest by category, name, or distance.
-Anonymous Rating System: Users can rate points of interest with a "Like" or "Dislike," with total ratings being displayed. Users can view and modify their previous ratings when revisiting these points of interest.
-Recent History: The last 10 viewed points of interest are saved locally and accessible through a dedicated screen.
-Location Services: The app uses the device's location to sort locations by proximity using the location library.

Data Handling:
-Server-Side Storage: The app pulls information from a Firebase, with the option to add ratings for points of interest.
-Local Storage: User interactions, such as ratings and recently viewed locations, are stored locally using shared_preferences to ensure ratings are only submitted once per point of interest.


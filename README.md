# AppStoreOffsiteTest

iOS App (Swift)
App Store listing page. 

- Xcode 8.0 / Swift 3.1
- iOS 9.0


# Description

The app has two modules: **Listing** and **AppDetail**.   

At home module, it will display trackings in 30 days and will show a status summary chat on the top. The tracking will be grouped by status. The display order of status is *Failed Attempt*, *Exception*, *Out for Delivery*, *In Transit*, *Info Received*, *Pending*, *Delivered* and *Expired*. So users can find the important shippment first. 

AllTrackings module will display 8 trackings every time and use infinite scroll to load more. In both home and allTrackings modules, it can push the trackingDetails module in and display all checkpoints and milestones for specified tracking.  




# Architectural

Using VIPER instead of MVC. 
VIPER is an application of Clean Architecture to iOS apps. It can help to avoid massive view controller problem in MVC. VIPER also make it easier to isolate dependencies (e.g. backend). 
I also create some classes and protocols. 
1. *AppStoreAPIClient*(Class): Communicates with backend. 
2. *JSONObjectRepresentable* & *JSONValueRepresentable*(Protocols): Helps to covert JSON from/to objects.
3. *Pagniator*(Class): For infinite scroll. Stores current page and limit. 


- ### Referance Diagram

![Referance Diagram](https://raw.github.com/harry-91/AppStoreOffsiteTest/master/Assets/Referance_Diagram.jpg)



- ### PassingData Diagram

![PassingData Diagram](https://raw.github.com/harry-91/AppStoreOffsiteTest/master/Assets/PassingData_Diagram.jpg)




# Screenshots

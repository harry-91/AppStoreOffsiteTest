# AppStoreOffsiteTest

iOS App (Swift)
App Store listing page. 

- Xcode 11.1 / Swift 5.0
- iOS 9.0


# Demo

![demo](Assets/Demo.gif)


# Architectural


The app has two modules: **Listing** and **AppDetail**.

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


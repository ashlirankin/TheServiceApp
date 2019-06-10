# Stylelists

<p align="center">
  <img src="https://user-images.githubusercontent.com/43770152/55572518-bf5bd480-56d5-11e9-8d84-ac654ef9d95b.png" />
</p>


StyleList is a iOS mobile app that connects you directly to hair-stylists, barbers, and makeup-artist to scehdule in home service. 


## APIs + Resources 

* [Stylist Demo at Museum of Moving Image (MOMA)](https://youtu.be/pEo6-znyzVI) 
* https://cocoapods.org/pods/Cosmos
* https://github.com/patchthecode/JTAppleCalendar
* https://stripe.com/

## Looking for a Provider
* The user browses through a list of providers (Barbers, Hairdressers, Makeup-Artist) on the Discovery tab.
* The user can use filter option at the top right to filter providers by availability, gender, profession, price, and services.
* After selecting a provider, the user can look at the provider's bio, porfolio, and rating.
* The user can favorite a provider if needed.

![LookingProvider](https://github.com/Ashlirankin18/TheServiceApp/blob/master/Stylist/Images/FindingProvider.gif)
![LookingProvider2](https://github.com/Ashlirankin18/TheServiceApp/blob/master/Stylist/Images/FindingProvider2.gif)

## Booking an Appointment
* To book an appointment, the user must select at least one service and a time.
* When the appointment request is sent, the user will receive a notification about the appointment.

![BookingAppointment](https://github.com/Ashlirankin18/TheServiceApp/blob/master/Stylist/Images/BookingAProvider.gif)

## Provider Checks and Confirm Appointment
* When the provider confirms the appointment, the user receives a notification that the appointment is confirmed.

![ConfirmAppointment](https://github.com/Ashlirankin18/TheServiceApp/blob/master/Stylist/Images/ConfirmAppointment.gif)

## Provider Completes Appointment and User Writes an Review
* After the service is finished, the provider would mark the appointment complete. When the appointment is marked complete, the user would receive a popup to write a review about the appointment.
* After the user submitted the review, it will reflect at the review section of the provider's profile.

![CompleteAppointment](https://github.com/Ashlirankin18/TheServiceApp/blob/master/Stylist/Images/CompleteAppointment.gif)

## Built With

* Firebase - This dependency allows us to get acess to the core methods and properties of Google's frameworks.

* FirebaseFirestore -  This dependency will allow us to create,read,write delete and update documents and colletions on the cloud Firestore database.

* Firebase Auth - This dependency allow us to create an "authenticated" user on firebase. It allows us to verify user login information and provides the relevant updates to inconsistencies with user's data. 

* Firebase Storage - Allows us to store user images and documents.

* Toucan - Aids in the resizing of images to insure that the firebase Storage quota is not expened quickly.

* KingFisher- Aids in the cacheing and rendering of images unto objects that inherit form ui view, such as: UIImage View, UIButton.

* MessageKit - Facilitates the communication between the service provider and the person using the service. It allows them to safely communicate and share information pertaining to the service that will be done.

* Cosmos - This dependency provides us with the stars that we require for the rating, review systems.

* Charts - This provides a awesome UI experience for the service provider. It allows them to view the earnings and other statistical data in app

## Prerequisites

* Xcode - 9.0+, set up on Swift Language
* iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
* Swift 4.0+

## Developers

* Ashli Rankin 
* Oneil Rosario
* Jabeen Cheema
* Jian Ting Li

//
//  GlobalStrings.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

// MARK: - Common Strings

struct ValidationMessages {
    static var firstName: String { return "Please enter first name".localized }
    static var lastName: String { return "Please enter last name".localized }
    static var emailOrMobileNumber: String { return "Please enter email ID or mobile number".localized }
    static var mobileNumber: String { return "Mobile number can not be empty".localized }
    static var validMobileNumber: String { return "Please enter a valid mobile number".localized }
    static var emailAddress: String { return "Please enter email address".localized }
    static var validEmailAddress: String { return "Please enter valid Email ID".localized }
    static var SelectTimeSloat: String { return "In order to book an appointment, please choose the appropriate time slot.".localized }
    static var password: String { return "Please enter a password".localized }
    static var passwordLength: String { return "Password length must be 8-20 characters".localized }
    static var OTP: String { return "Please enter OTP".localized }
    static var validOTP: String { return "Please enter a valid OTP".localized }

    static var teamName: String { return "Please enter your team name".localized }
    static var internetMSG: String { return "Internet connection appears to be offline".localized }

    static var ConfirmPassword: String { return "Please enter Confirm Password".localized }
    static var newPassword: String { return "Please enter your new password".localized }
    static var newPasswordLength: String { return "New password length must be 8-20 characters".localized }
    static var confirmPassword: String { return "Confirm your password".localized }
    static var confirmPasswordLength: String { return "Confirm password length must be 8-20 characters".localized }
    static var notMatchPassword: String { return "Password & Confirm Password must match".localized }
    static var noCityAvailable: String { return "Cities not available for the specified region".localized }

    static var NoRecordsFound: String { return "No records found".localized }
    static var NoTimeSlotsFound: String { return "No time slots are available for the selected date.".localized }
    // Contact Us
    static var name: String { return "Please enter name".localized }
    static var message: String { return "Please enter message".localized }
    static var selectReason: String { return "Please select reason".localized }
    static var attachScreenshot: String { return "Please attach screenshot".localized }

    // Account Verification
    static var uploadPan: String { return "Please upload photo of your pan card".localized }
    static var enterPanName: String { return "Please enter name as on pan card".localized }
    static var enterPanNumber: String { return "Please enter pan number".localized }
    static var enterVaildPanNumber: String { return "Please enter valid pan number".localized }
    static var selectBirthdate: String { return "Please select date of birth".localized }
    static var selectState: String { return "Please select state".localized }
    static var enterGameName: String { return "Please enter game name".localized }

    static var uploadBankDetail: String { return "Please upload your bank account proof".localized }
    static var bankAccNumber: String { return "Please enter bank account number".localized }
    static var bankAccHolderName: String { return "Please enter account holder's name".localized }
    static var bankName: String { return "Please enter bank name".localized }
    static var bankBranch: String { return "Please enter bank branch bane".localized }
    static var bankIFSC: String { return "Please enter IFSC code".localized }

    // Withdraw
    static var withDrawAmount: String { return "Please enter withdraw amount".localized }
    static var noWiningAmount: String { return "You don't have much wining amount".localized }
    static var withdrawAmountExceed: String { return "You don't have sufficient amount in your wallet to withdraw".localized }

    static var MSGTokenExpire: String { return "You have been logged out of the application. Please login again.".localized }

    static var InCompleteProfile: String { return "Please fill up your details by clicking on Edit button below".localized }

    // Dob and State

    static var cannotJoinLeague_invalidState: String { return "You cannot play contests with real money since you are either under 18 years of age, not a resident of India or you belong to the states of Assam, Odisha, Telangana, Nagaland or Sikkim.".localized }
}

enum AlertMessages {
    static var ALERT_PHOTO_LIBRARY_MESSAGE: String { return "This app does not have access to your photos. To enable access, go to Settings and turn on Photo Library Access.".localized }
    static var ALERT_CAMERA_ACCESS_MESSAGE: String { return "This app does not have access to your camera. To enable access, go to settings and turn on Camera.".localized }
}

enum SidemenuItem {
    static var MyProfile: String { return "My Profile".localized }
    static var Home: String { return "Home".localized }
    static var MyAppointment: String { return "My Appointments".localized }
    static var MyRecords: String { return "My Records".localized }
    static var BookyRecords: String { return "Book Records".localized }
    static var Settings: String { return "Settings".localized }
    static var Language: String { return "Language".localized }
    static var AboutUs: String { return "About".localized }
    static var Support: String { return "Support".localized }
    static var Logout: String { return "Logout".localized }
}

enum SidemenuImages {
    static var MyProfile = "ic_user"
    static var Home = "ic_Home"
    static var MyAppointment = "ic_MyAppointments"
    static var MyRecords = "ic_MyRecords"
    static var BookyRecords = "ic_BookRecords"
    static var Settings = "ic_Settings"
    static var Language = "ic_Language"
    static var AboutUs = "ic_About"
    static var Support = "ic_Support"
    static var Logout = "ic_Logout"
}

enum Strings {
    static var ProductReview: String { return "Product review has been successfully added".localized }
    static var AlertOk: String { return "OK".localized }
    static var AlertYes: String { return "Yes".localized }
    static var AlertNO: String { return "No".localized }
    static var Logout: String { return "Are you sure you want to logout?".localized }
    static var ReadMore: String { return "Read more".localized }
    static var EmptyList: String { return "No data found".localized }
    static var AboutUsNavTitle: String { return "About Us".localized }
    static var Support: String { return "Support".localized }
    static var PrivacyNavTitle: String { return "Privacy Policy".localized }
    static var FAQsNavTitle: String { return "FAQs".localized }
    static var CannotEmpty: String { return "can not be empty".localized }
    static var ValidEmailAddress: String { return "Please enter valid Email ID".localized }
    static var NotMatchPassword: String { return "Passwords entered do not match".localized }
    static var RegionSelectFirst: String { return "Please select Region first".localized }
    static var NoCityAvailable: String { return "Cities not available for the specified region".localized }
    static var SomethingWentWrong: String { return "Something went wrong".localized }
    static var ItemAddedToCart: String { return "Item added to cart".localized }
    static var PasswordCharacterValidatin: String { return "Your password should contain at least eight characters".localized }
    static var Edit: String { return "Edit".localized }
    static var SAR: String { return "SAR".localized }
    static var NextTimeSlot: String { return "Next available time slot".localized }

    static var Button_Cancel: String { return "Cancel".localized }
    static var Button_Done: String { return "Done".localized }
}

enum Strings_LangaugeSelectionVC {
    static var Title: String { return "Select Language".localized }
    static var Button_English: String { return "English".localized }
    static var Button_Arabic: String { return "Arabic".localized }
    static var Button_Submit: String { return "Submit".localized }
}

enum Strings_ECProductListVC {
    static var Label_Filter: String { return "Filter".localized }
    static var Label_SortBy: String { return "Sort By".localized }
    static var Label_SortByRelevance: String { return "Relevance".localized }
    static var Label_SortByHighestPrice: String { return "Highest price".localized }
    static var Label_SortByLowestPrice: String { return "Lowest price".localized }
    static var Label_SortByNewestFirst: String { return "Newest first".localized }
    static var Button_Done: String { return "Done".localized }
    static var Button_Cancel: String { return "Cancel".localized }
}

enum Strings_ECProductDetailsVC {
    static var Label_CheckDeliveryInfo: String { return "Use pincode to check delivery info".localized }
    static var Label_SameDayDelivery: String { return "Same Day Delivery".localized }
    static var Label_AvailableStorePickUp: String { return "Available for Store Pick Up".localized }
    static var Label_AddToBasket: String { return "Add to Basket".localized }
    static var Label_AddToWishList: String { return "Add to Wishlist".localized }
    static var Label_RemoveFromWishList: String { return "Remove from Wishlist".localized }
    static var Label_ShareItem: String { return "Share this item".localized }
    static var Label_Missthisoffers: String { return "Don't Miss these offers".localized }
    static var Button_WriteReview: String { return "Write a review".localized }
    static var Button_CheckStoreStock: String { return "Check Store Stock".localized }
}

enum Strings_EC_WriteReviewVC {
    static var NavTitle: String { return "Write a review".localized }
    static var Label_NickName: String { return "Nickname".localized }
    static var Label_Email: String { return "Email".localized }
    static var Label_OveralRating: String { return "Overall Rating".localized }
    static var Label_ReviewTitle: String { return "Review Title".localized }
    static var Label_Review: String { return "Review".localized }
    static var Label_ReviewDesc: String { return "You may receive emails regarding this submission. Any emails will include the ability to opt-out future commnications.".localized }
    static var Button_PostReview: String { return "POST REVIEW".localized }
}

enum Strings_ECProccedCheckOutVC {
    static var NavTitle: String { return "Shopping Cart".localized }
}

enum Strings_ECPharmacyShoppingVC {
    static var NavTitle: String { return "Pharmacy Shopping".localized }
    static var Label_ShopByCategory: String { return "Shop by category".localized }
    static var Label_TopSellers: String { return "Top Sellers".localized }
}

enum Strings_ECTabBarItems {
    static var Home: String { return "Home".localized }
    static var Cateories: String { return "Categories".localized }
    static var Cart: String { return "Cart".localized }
    static var More: String { return "More".localized }
}

enum Strings_ECCategoriesVC {
    static var NavTitle: String { return "Categories".localized }
}

enum Strings_ECCartVC {
    static var NavTitle: String { return "Shopping Cart".localized }
    static var Label_Price: String { return "Price".localized }
    static var Label_Subtotal: String { return "Subtotal".localized }
    static var Label_Summary: String { return "Summary".localized }
    static var Label_ApplyCoupon: String { return "APPLY COUPON".localized }
    static var Label_VAT: String { return "VAT".localized }
    static var Label_OrderTotal: String { return "Order Total".localized }
    static var Label_Discount: String { return "Discount".localized }
    static var Label_CuponCode: String { return "Coupon Code".localized }
    static var Button_Edit: String { return "Edit".localized }
    static var Button_Remove: String { return "Remove".localized }
    static var Button_ApplyCoupon: String { return "Apply Coupon".localized }
    static var Button_ProccedCheckOut: String { return "PROCEED TO CHECKOUT".localized }
    static var Button_UpdateBasket: String { return "UPDATE BASKET".localized }
}

enum Strings_DoctorSelectionVC {
    static var NavTitle: String { return "Doctors".localized }
    static var book: String { return "Book".localized }
    static var searchPlaceholder: String { return "What are you looking for?".localized }
    static var AvailableTOday: String { return "Available Today".localized }
    static var msgNodataFound: String { return "The doctor you are looking for is not available for booking at the moment.".localized }
}

enum Strings_ECMoreVC {
    static var NavTitle: String { return "More".localized }
}

enum Strings_HomeVC {
    static var Label_Consulation: String { return "".localized }
    static var Label_Quick: String { return "Telemedicine".localized }
    static var Label_Prescription: String { return "Prescription Dispensing".localized }
    static var Label_Request: String { return "".localized }
    static var Label_Pharmacy: String { return "ePharmacy".localized }
    static var Label_Shopping: String { return "".localized }
    static var NavTitle: String { return "Home".localized }
    static var Label_ConsulationDescription: String { return "Get an urgent or scheduled medical consultation.".localized }
    static var Label_PrescriptionDescription: String { return "Send us your prescription & we’ll deliver it to you.".localized }
    static var Label_PharmacyDescription: String { return "Shop for your favorite products.".localized }
}

enum Strings_OrderListVC {
    static var NavTitle: String { return "My Order".localized }
    static var Label_OrderID: String { return "Order ID:".localized }
    static var Label_OrderDate: String { return "Date:".localized }
    static var Label_OrderTime: String { return "Time:".localized }
    static var Label_Status: String { return "Status:".localized }
    static var Label_Cancel: String { return "Cancel".localized }
    static var Label_AttachedPrescription: String { return "Attached Prescriptions:".localized }
}

enum Strings_MyAppointmentVC {
    static var NavTitle: String { return "My Appointment".localized }
}

enum Strings_MyAppointmentDetailsVC {
    static var lblStatus: String { return "Status:".localized }
    static var NavTitle: String { return "Appointment Details".localized }
    static var lblDoctorInfo: String { return "Doctor Info".localized }
    static var lblIssue: String { return "What is your issue?".localized }
}

enum Strings_PaymentTranssactionVC {
    static var NavTitle: String { return "Appointment Details".localized }
}

enum Strings_PaymentOptionsVC {
    static var NavTitle: String { return "Payment Options".localized }
    static var Label_CardNumber: String { return "Card Number".localized }
    static var Label_ExpiraryDate: String { return "Expiration Date".localized }
    static var Label_CVV: String { return "CVV".localized }
    static var Label_CardHolderName: String { return "Cardholder's Name".localized }
    static var Button_Next: String { return "NEXT".localized }
}

enum Strings_OrderDetailsVC {
    static var NavTitle: String { return "Order Details".localized }
    static var Label_OrderID: String { return "Order ID:".localized }
    static var Label_OrderDate: String { return "Date:".localized }
    static var Label_OrderTime: String { return "Time:".localized }
    static var Label_OrderWasFatiNumber: String { return "WASFASTI Number:".localized }
}

enum Strings_OrderMedicineVC {
    static var NavTitle: String { return "Order Medicine".localized }
    static var Button_WasfatiPrescription: String { return "WASFASTI prescription".localized }
    static var Button_UploadPrescription: String { return "Upload prescription".localized }
}

enum Strings_OrderWasfatiMedicineVC {
    static var NavTitle: String { return "Order Medicine".localized }
    static var Label_OrderWasFatiNumber: String { return "WASFASTI Number*".localized }
    static var Button_WasfatiPrescription: String { return "WASFASTI prescription".localized }
    static var Button_Submit: String { return "NEXT".localized }
    static var Label_OrderPatientID: String { return "Patient ID*".localized }
}

enum Strings_OrderUploadMedicineVC {
    static var NavTitle: String { return "Order Medicine".localized }
    static var Button_UploadPrescription: String { return "Upload prescription".localized }
    static var Button_NEXT: String { return "NEXT".localized }
}

enum Strings_ChangePasswordVC {
    static var NavTitle: String { return "Change Password".localized }
    static var Label_OldPassword: String { return "Old Password*".localized }
    static var Label_NewPassword: String { return "New Password*".localized }
    static var Label_ConfirmPassword: String { return "Confirm Password*".localized }
    static var Button_Submit: String { return "SUBMIT".localized }
}

enum Strings_ProfileVC {
    static var NavTitle: String { return "Profile".localized }
    static var Label_FirstName: String { return "First Name*".localized }
    static var Label_MiddleName: String { return "Middle Name*".localized }
    static var Label_LastName: String { return "Last Name*".localized }
    static var Label_Email: String { return "Email ID*".localized }
    static var Label_Password: String { return "Password*".localized }
    static var Label_PrimryContact: String { return "Phone*".localized }
    static var Label_Code: String { return "Code*".localized }

    static var Label_NationalID: String { return "National id/iqama*".localized }
    static var Label_Age: String { return "Age*".localized }
    static var Label_Gender: String { return "Gender*".localized }
    static var Label_DoB: String { return "Date of Birth*".localized }

    static var btnSubMit: String { return "SAVE".localized }

    static var btnChangeMobile: String { return "Change Mobile Number".localized }
    static var btnChangeEmail: String { return "Change Email ID".localized }

    static var btnAddMobile: String { return "Add Mobile Number".localized }
    static var btnAddEmail: String { return "Add Email ID".localized }

    static var btnChangeCalandarGeor: String { return "Use Georgian".localized }
    static var btnChangeCalandarIslamic: String { return "Use Islamic".localized }
}

enum Strings_ContactUsVC {
    static var NavTitle: String { return "Contact Us".localized }
}

enum Strings_NotificatonListVC {
    static var NavTitle: String { return "Notification".localized }
}

enum Strings_AddAddressVC {
    static var NavUpdateTitle: String { return "Update Address".localized }
    static var NavTitle: String { return "Add New Address".localized }
    static var Label_Title: String { return "Title*".localized }
    static var Label_AddressLine1: String { return "Address Line 1*".localized }
    static var Label_AddressLine2: String { return "Address Line 2*".localized }
    static var Label_City: String { return "City*".localized }
    static var Label_Region: String { return "Region*".localized }
    static var Label_ZipCode: String { return "Zip Code*".localized }
    static var Label_AdditionalCode: String { return "Additional Code*".localized }
    static var Button_Save: String { return "SAVE".localized }
    static var Label_NoAddressSelect: String { return "Please select address".localized }
}

// MARK: - Login Option VC

enum Strings_LoginOptionVC {
    static var Title: String { return "Sign In".localized }
    static var Button_MobilenumberOTP: String { return "Mobile Number OTP".localized }
    static var Label_OR: String { return "OR".localized }
    static var Button_ContinueWithPassword: String { return "Continue with password".localized }
    static var Label_DontHaveAccount: String { return "Don't have an account?".localized }
    static var Button_SignUp: String { return "Sign Up".localized }
}

enum Strings_TranscationVC {
    static var NavTitle: String { return "Success".localized }
    static var FailNavTitle: String { return "Failure".localized }
}

enum Strings_LoginWithOTPVC {
    static var Title: String { return "Verify OTP".localized }
    static var Button_LOgin: String { return "SUBMIT".localized }
    static var Label_Mobile: String { return "Mobile No.*".localized }
    static var Label_Code: String { return "Code No.*".localized }
    static var Code966: String { return "+966".localized }
}

enum Strings_LoginWithEmailVC {
    static var Button_LOgin: String { return "Log In".localized }
    static var Button_SIgnUP: String { return "Don't have an account? Register".localized }
    static var Button_Forgot: String { return "Forgot Password?".localized }
    static var Label_Email: String { return "EmailD".localized }
    static var Label_Password: String { return "Password".localized }
}

enum Strings_SignUpVC {
    static var Title: String { return "Sign Up".localized }
    static var Button_LOgin: String { return "SIGN UP".localized }
    static var Label_Email: String { return "Email ID/Mobile Number".localized }
    static var Label_Password: String { return "Password".localized }
    static var Label_ConfirmPassword: String { return "Confirm Password".localized }
}

enum Strings_QuickSelectionVC {
    static var Title: String { return "Quick Consultation".localized }
    static var Button_UTC: String { return "Urgent Teleconsultation".localized }
    static var Button_NUTC: String { return "Schedule Teleconsultation".localized }
}

enum Strings_SelectAddress {
    static var Title: String { return "Select Address".localized }
    static var Button_CL: String { return "Current Location".localized }
    static var Button_SL: String { return "Saved Location".localized }
    static var Button_SLM: String { return "Select Location Manually".localized }
    static var Label_Top: String { return "Where do you want service?".localized }
}

enum Strings_PatientInfoVC {
    static var Title: String { return "Patient Information".localized }
    static var lblAddress: String { return "Address".localized }
    static var lblPatientInfo: String { return "Patient Information".localized }
    static var lblFullName: String { return "Full Name".localized }
    static var lblMobilenumber: String { return "Mobile Number".localized }
    static var lblMsG: String { return "Complaint Message".localized }
    static var btnNext: String { return "NEXT".localized }
}

enum Strings_ForgotPassword {
    static var Title: String { return "Forgot Password".localized }
    static var Label_Email: String { return "Email".localized }
    static var btnSubMit: String { return "Send".localized }
}

enum Strings_NonUrgent {
    static var Title: String { return "Non-urgent".localized }
    static var Appointmenttitle: String { return "Pick Appointment Time".localized }
}

enum Strings_SelectDataTime {
    static var Title: String { return "Select Date & Time".localized }
    static var Appointmenttitle: String { return "Pick Appointment Time".localized }
}

enum StringsMapVC {
    static var btnSelectLocation: String { return "Place Order".localized }
}

enum Strings_UrgentAppointmentvc {
    static var Title: String { return "Appointment".localized }
    static var TOPTitle1: String { return "We provide an urgent consultation with Urgent care specialist within maximum 2hrs of your booking.".localized }
    static var TOPTitle2: String { return "You can book through the app and we will get back to you asap.".localized }
    static var btnBook: String { return "Book Now".localized }
    static var callUs: String { return "You can Call us on".localized }
}

enum Strings_ForWhomAppointmentvc {
    static var Title: String { return "Appointment".localized }
    static var TitleOrder: String { return "Prescription".localized }

    static var TOPTitle: String { return "Is this Appointment for you?".localized }
    static var TOPUrgentTitle: String { return "Is this Urgent Appointment for you?".localized }
    static var ORDerTITle: String { return "is this prescription for you?".localized }
    static var btnYes: String { return "Yes, Me".localized }
    static var btnSomeone: String { return "Someone else".localized }
}

enum Strings_NoAvailableBookingvc {
    static var Title1: String { return "No Available Booking".localized }
    static var title2: String { return "Apologies, all our urgent care doctors are busy now, please call us on".localized }
    static var title3: String { return "or try to book a regular appointment later today.".localized }
}

enum Strings_PlantoPayvc {
    static var Title: String { return "ORDER".localized }
    static var TOPTitle: String { return "How Do You Plan to pay?".localized }
    static var btnYes: String { return "Cash".localized }
    static var btnSomeone: String { return "Insurance".localized }
    static var Label_Id: String { return "National id/iqama*".localized }
}

enum Strings_AddPatientInfovc {
    static var Title: String { return "Patient Details".localized }
    static var Label_Name: String { return "Name*".localized }
    static var Label_Relation: String { return "Patient Relationship to you*".localized }
    static var Label_Code: String { return "Code*".localized }

    static var Label_Phone: String { return "Phone*".localized }
    static var Label_Id: String { return "National id/iqama*".localized }
    static var Label_DoB: String { return "Date of Birth*".localized }
    static var Label_Age: String { return "Age*".localized }

    static var Label_Gender: String { return "Gender*".localized }
    static var Label_issue: String { return "What is your issue?".localized }
    static var btn_Next: String { return "NEXT".localized }
    static var PaymentTitle: String { return "Payment".localized }
}

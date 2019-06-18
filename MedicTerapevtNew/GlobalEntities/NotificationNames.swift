//
//  NotificationNames.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


enum NotificationNames: String {
    
    case newMessage = "new message"
    case socketConnected = "socket connected"
    case messagesFetched = "messagesFetched"
    
    case calendarOpened = "CalendarOpened"
    case calendarClosed = "CalendarClosed"
    
    
    case enterRequestAnswered = "enterRequestAnswered"
    case registrationRequestAnswered = "registrationRequestAnswered"
    case confirmationRequestAnswered = "confirmationRequestAnswered"
    case sendCodeForgotPasswordRequestAnswered = "sendCodeForgotPasswordRequestAnswered"
    case confirmForgotPasswordRequestAnswered = "confirmForgotPasswordRequestAnswered"
    
    case getProfileRequestAnswered = "getProfileRequestAnswered"
    case postProfileRequestAnswered = "postProfileRequestAnswered"
    case profileSavingBegan = "profileSavingBegan"
    
    case reserveRequestAnswered = "reserveRequestAndsered"
    case getValidHoursRequestAnswered = "getValidHoursRequestAnswered"
    case getReservationsRequestAnswered = "getReservationsRequestAnswered"
    
    case getAllExercisesRequestAnswered = "getAllExercisesRequestAnswered"
}

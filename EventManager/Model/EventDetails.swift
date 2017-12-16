//
//  EventDetails.swift
//  EventManager
//
//  Created by vera on 11/23/17.
//  Copyright © 2017 vera. All rights reserved.
//

import Foundation

class EventDetails{
    var eventName:String?
    var eventDate:Date?
    
    init(eventName:String, eventDate:Date) {
       self.eventName = eventName
       self.eventDate = eventDate
    }
}

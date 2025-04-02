//
//  Bus.swift
//  SwiftRide
//
//  Created by Ashraf Alif Adillah on 17/03/25.
//

import Foundation

class Bus {
    private var _id: String
    private var _name: String
    private var _policeNumber: String
//    private var _route: Route
    
    init(_id: String, _name: String, _policeNumber: String) {
        self._id = _id
        self._name = _name
        self._policeNumber = _policeNumber
//        self._route = _route
    }
}

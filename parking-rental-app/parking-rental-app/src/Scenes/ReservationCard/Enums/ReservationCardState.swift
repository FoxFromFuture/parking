//
//  ReservationCardState.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/15/24.
//

enum ReservationCardState {
    case loading
    case loaded
    case error
    case reservationsLimit
    case reservationsLimitForTime
    case weekendLimit
}

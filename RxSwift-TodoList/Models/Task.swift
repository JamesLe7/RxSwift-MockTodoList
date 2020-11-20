//
//  Task.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/19/20.
//

import Foundation

enum Priority: Int {
    case high = 0
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}

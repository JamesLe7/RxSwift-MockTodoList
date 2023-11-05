//
//  Task.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/19/20.
//

import Foundation

enum TaskPriority: String, Equatable, CaseIterable {
  case high = "High"
  case medium = "Medium"
  case low = "Low"
  
  init?(priorityIndex: Int) {
    switch priorityIndex {
    case 0:
      self = .high
    case 1:
      self = .medium
    case 2:
      self = .low
    default:
      return nil
    }
  }
}

struct Task: Equatable {
  let title: String
  let priority: TaskPriority
}

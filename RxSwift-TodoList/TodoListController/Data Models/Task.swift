//
//  Task.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/19/20.
//

import Foundation

struct Task: Equatable {
  let title: String
  let priority: TaskPriority
}

enum TaskPriority: String, Equatable, CaseIterable {
  case high = "High"
  case medium = "Medium"
  case low = "Low"
  
  static let segmentedControlTitles = allCases.map { $0.rawValue }
}

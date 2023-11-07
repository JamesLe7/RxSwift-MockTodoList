//
//  AddTaskViewModel.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/5/23.
//

import Foundation
import RxCocoa
import RxSwift

final class AddTaskViewModel {

  let title = "Add Task"
  private let segmentedControlTitles = TaskPriority.segmentedControlTitles
  
  init() {}

  func getSegementedControlTitles() -> [String] {
    return segmentedControlTitles
  }

  func getTaskPriority(for segmentIndex: Int) -> TaskPriority? {
    guard segmentIndex >= 0 && segmentIndex < segmentedControlTitles.count else {
      return nil
    }
    return TaskPriority(rawValue: segmentedControlTitles[segmentIndex])
  }

  func isTextFieldInputValid(_ text: String?) -> Bool {
    guard let textIsReallyEmpty = text?.isReallyEmpty else {
      return false
    }
    return !textIsReallyEmpty
  }
}

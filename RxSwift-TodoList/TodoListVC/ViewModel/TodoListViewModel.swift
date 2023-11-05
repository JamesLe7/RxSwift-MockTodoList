//
//  TodoListViewModel.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 9/16/23.
//

import Foundation
import RxCocoa
import RxSwift

final class TodoListViewModel {

  private var tasks: [Task] = []
  private var filteredTaskList: BehaviorRelay<[Task]>
  private let segmentedControlTitles = ["All"] + TaskPriority.allCases.map { $0.rawValue }
  
  init() {
    filteredTaskList = BehaviorRelay(value: tasks)
  }
  
  func getSegmentControlTitle(for segmentIndex: Int) -> String? {
    guard segmentIndex >= 0 && segmentIndex < segmentedControlTitles.count else {
      return nil
    }
    return segmentedControlTitles[segmentIndex]
  }

  func segmentControlTitles() -> [String] {
    segmentedControlTitles
  }

  func addTask(_ value: Task) {
    tasks.append(value)
    filteredTaskList.accept(tasks)
  }
  
  func filterTasks(prioritySegmentSelected: Int) {
    guard let priority = TaskPriority(priorityIndex: prioritySegmentSelected) else {
      filteredTaskList.accept(tasks)
      return
    }
    let filteredTasks = tasks.filter { $0.priority == priority }
    filteredTaskList.accept(filteredTasks)
  }
}

extension TodoListViewModel {
  func numberSections() -> Int {
    1
  }

  func numberOfRowsForSection(_ section: Int) -> Int {
    filteredTaskList.value.count
  }
  
  func titleForRow(_ row: Int) -> String {
    filteredTaskList.value[row].title
  }
}

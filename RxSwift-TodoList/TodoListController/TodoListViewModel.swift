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

  let title = "Todo-List"
  private var tasks: [Task]
  private(set) var filteredTaskList: BehaviorRelay<[Task]>
  private let segmentedControlTitles = ["All"] + TaskPriority.segmentedControlTitles
  
  init(tasks: [Task] = []) {
    self.tasks = tasks
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
    guard let priorityTitle = getSegmentControlTitle(for: prioritySegmentSelected),
          let priority = TaskPriority(rawValue: priorityTitle) else {
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
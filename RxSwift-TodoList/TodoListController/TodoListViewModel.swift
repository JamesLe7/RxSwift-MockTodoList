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
  
  func update(_ action: Action) {
    switch action {
    case let .addTask(task):
      tasks.append(task)
      filteredTaskList.accept(tasks)
      
    case let .filterTasks(prioritySegmentSelected):
      guard let priorityTitle = getSegmentControlTitle(for: prioritySegmentSelected),
            let priority = TaskPriority(rawValue: priorityTitle) else {
        filteredTaskList.accept(tasks)
        return
      }
      let filteredTasks = tasks.filter { $0.priority == priority }
      filteredTaskList.accept(filteredTasks)
      
    case let .removeTask(task):
      tasks.removeAll { $0 == task }
      filteredTaskList.accept(tasks)
    }
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

extension TodoListViewModel {
  enum Action: Equatable {
    case addTask(Task)
    case filterTasks(_ prioritySegmentedSelected: Int)
    case removeTask(Task)
  }
}

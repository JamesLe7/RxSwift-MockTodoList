//
//  ViewController.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/16/20.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoListViewController: UIViewController {

  // MARK: - Properties
  private let addTaskBarButton = UIBarButtonItem(systemItem: .add)
  
  private let segmentControlContainerView = UIView()
  
  private var taskPrioritySegmentControl: UISegmentedControl

  private let listTableView = UITableView()
  
  private let viewModel: TodoListViewModel
  
  private let disposeBag = DisposeBag()
  
  init(viewModel: TodoListViewModel = TodoListViewModel()) {
    self.viewModel = viewModel
    self.taskPrioritySegmentControl = UISegmentedControl(items: viewModel.segmentControlTitles())
    super.init(nibName: nil, bundle: nil)
    
    viewModel.filteredTaskList.subscribe(onNext: { [weak self] _ in
      self?.reloadTableView()
    }).disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = viewModel.title
    view.backgroundColor = .white
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemRed]

    addTaskBarButton.tintColor = .systemRed
    addTaskBarButton.target = self
    addTaskBarButton.action = #selector(addTaskTapped)
    navigationItem.rightBarButtonItem = addTaskBarButton

    taskPrioritySegmentControl.backgroundColor = .systemGray5
    taskPrioritySegmentControl.resetSelectedSegmentToFirstIndex()
    taskPrioritySegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
    taskPrioritySegmentControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    segmentControlContainerView.translatesAutoresizingMaskIntoConstraints = false
    taskPrioritySegmentControl.translatesAutoresizingMaskIntoConstraints = false
    
    listTableView.delegate = self
    listTableView.dataSource = self
    listTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
    listTableView.backgroundColor = .white
    listTableView.translatesAutoresizingMaskIntoConstraints = false
    
    segmentControlContainerView.addSubview(taskPrioritySegmentControl)
    view.addSubview(segmentControlContainerView)
    view.addSubview(listTableView)

    NSLayoutConstraint.activate([
      segmentControlContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentControlContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      segmentControlContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      taskPrioritySegmentControl.topAnchor.constraint(equalTo: segmentControlContainerView.topAnchor, constant: 8),
      taskPrioritySegmentControl.leadingAnchor.constraint(equalTo: segmentControlContainerView.leadingAnchor, constant: 16),
      taskPrioritySegmentControl.trailingAnchor.constraint(equalTo: segmentControlContainerView.trailingAnchor, constant: -16),
      taskPrioritySegmentControl.bottomAnchor.constraint(equalTo: segmentControlContainerView.bottomAnchor, constant: -8),
      taskPrioritySegmentControl.heightAnchor.constraint(equalToConstant: 25),
      
      listTableView.topAnchor.constraint(equalTo: segmentControlContainerView.bottomAnchor),
      listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  // MARK: - Helper Methods
  private func reloadTableView() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.listTableView.reloadData()
    }
  }
  
  // MARK: - Selector Methods
  @objc private func segmentedControlTapped() {
    viewModel.filterTasks(prioritySegmentSelected: taskPrioritySegmentControl.selectedSegmentIndex)
  }

  @objc private func addTaskTapped() {
    let addTaskVC = AddTaskViewController()

    addTaskVC.taskSubjectObservable.subscribe(onNext: { [weak self] task in
      guard let self else { return }
      self.viewModel.addTask(task)
      self.taskPrioritySegmentControl.resetSelectedSegmentToFirstIndex()
    }).disposed(by: disposeBag)
    
    present(addTaskVC, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = TodoListPriorityHeader()
    header.title = viewModel.getSegmentControlTitle(
      for: taskPrioritySegmentControl.selectedSegmentIndex
    )
    return header
  }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsForSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as! TaskCell
    cell.title = viewModel.titleForRow(indexPath.row)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

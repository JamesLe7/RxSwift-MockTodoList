//
//  ViewController.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/16/20.
//

import UIKit
import RxSwift
import RxCocoa

class TodoListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let addTaskBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .add)
        barButtonItem.tintColor = .systemRed
        return barButtonItem
    }()
    
    private let prioritySegementedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All","High","Medium","Low"])
        segmentedControl.backgroundColor = .systemGray5
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let taskListTableView = UITableView()
    
    private let addTaskVC = AddTaskViewController()
    
    private var taskList = BehaviorRelay<[Task]>(value: [])
    
    private var filteredTaskList = [Task]()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        subscribeToTaskSubject()
    }
     
    // MARK: - Helper Methods

    private func configureUI() {
        configureNavBarUI()
        configureViewController()
        configureSegementedControl()
        configureTableView()
    }
    
    private func configureNavBarUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemRed]
        
        addTaskBarButtonItem.target = self
        addTaskBarButtonItem.action = #selector(addTaskTapped)
        navigationItem.rightBarButtonItem = addTaskBarButtonItem
    }
    
    private func configureViewController() {
        title = "Todo-List"
        view.backgroundColor = .white
    }
    
    private func configureSegementedControl() {
        view.addSubview(prioritySegementedControl)
        prioritySegementedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        prioritySegementedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        prioritySegementedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configureTableView() {
        view.addSubview(taskListTableView)
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.register(TaskCell.self, forCellReuseIdentifier: K.taskCellReuseIdentifier)
        taskListTableView.backgroundColor = .white
        
        taskListTableView.translatesAutoresizingMaskIntoConstraints = false
        taskListTableView.topAnchor.constraint(equalTo: prioritySegementedControl.bottomAnchor, constant: 15).isActive = true
        taskListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        taskListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        taskListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func getTableViewHeaderTitle() -> String {
        switch prioritySegementedControl.selectedSegmentIndex {
        case 0: return "All"
        case 1: return "High"
        case 2: return "Medium"
        case 3: return "Low"
        default: return "All"
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            filteredTaskList = taskList.value
        } else {
            self.taskList.map({ tasks in
                return tasks.filter({ $0.priority == priority! })
            }).subscribe(onNext: { [weak self] tasks in
                guard let self = self else { return }
                self.filteredTaskList = tasks
            }).disposed(by: disposeBag)
        }
    }
    
    private func subscribeToTaskSubject() {
        addTaskVC.taskSubjectObservable.subscribe(onNext: { [weak self] task in
            guard let self = self else { return }
            var existingTasks = self.taskList.value
            existingTasks.append(task)
            self.taskList.accept(existingTasks)
            self.filterTasks(by: Priority(rawValue: self.prioritySegementedControl.selectedSegmentIndex - 1))
            DispatchQueue.main.async {
                self.taskListTableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Selector Methods
    
    @objc private func addTaskTapped() {
        addTaskVC.modalPresentationStyle = .fullScreen
        present(addTaskVC, animated: true, completion: nil)
    }
    
    @objc private func segmentedControlTapped() {
        filterTasks(by: Priority(rawValue: (prioritySegementedControl.selectedSegmentIndex - 1)))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.taskListTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TaskListTableViewHeader()
        header.title = getTableViewHeaderTitle()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDataSource

extension TodoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.taskCellReuseIdentifier, for: indexPath) as! TaskCell
        cell.title = filteredTaskList[indexPath.row].title
        return cell
    }
}

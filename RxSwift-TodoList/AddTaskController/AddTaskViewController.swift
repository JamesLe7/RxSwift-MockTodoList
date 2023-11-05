//
//  AddTaskViewController.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/17/20.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
  
  // MARK: - Properties
  
  private let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Cancel", for: .normal)
    button.tintColor = .systemRed
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let doneButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Done", for: .normal)
    button.isEnabled = false
    button.tintColor = .systemRed
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let prioritySegementedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: TaskPriority.allCases.map { $0.rawValue })
    segmentedControl.backgroundColor = .systemGray5
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
    segmentedControl.resetSelectedSegmentToFirstIndex()
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()
  
  private let inputTaskTextField: UITextField = {
    let textField = UITextField()
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
    textField.leftViewMode = .always
    textField.layer.cornerRadius = 2
    textField.layer.borderWidth = 1.5
    textField.layer.borderColor = UIColor.systemRed.cgColor
    textField.placeholder = "Input Task Here"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let viewModel: AddTaskViewModel
  
  private let taskSubject = PublishSubject<Task>()
  
  var taskSubjectObservable: Observable<Task> {
    return taskSubject.asObservable()
  }
  
  init(viewModel: AddTaskViewModel = AddTaskViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = viewModel.title
    view.backgroundColor = .white
    cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
    doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    inputTaskTextField.addTarget(self,action: #selector(handleTextField), for: .editingChanged)
    configureUI()
  }
  
  // MARK: - Helper Methods
  
  private func configureUI() {
    configureTopButtons()
    configureSegmentedControl()
    configureTextField()
  }
  
  private func configureTopButtons() {
    view.addSubview(cancelButton)
    cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
    cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
    
    view.addSubview(doneButton)
    doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
  }
  
  private func configureSegmentedControl() {
    view.addSubview(prioritySegementedControl)
    prioritySegementedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    prioritySegementedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  private func configureTextField() {
    view.addSubview(inputTaskTextField)
    inputTaskTextField.delegate = self
    inputTaskTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70).isActive = true
    inputTaskTextField.heightAnchor.constraint(equalTo: inputTaskTextField.widthAnchor, multiplier: 0.10).isActive = true
    inputTaskTextField.topAnchor.constraint(equalTo: prioritySegementedControl.bottomAnchor, constant: 15).isActive = true
    inputTaskTextField.centerXAnchor.constraint(equalTo: prioritySegementedControl.centerXAnchor).isActive = true
  }
  
  private func resetInputFields() {
    inputTaskTextField.text = ""
    doneButton.isEnabled = false
  }
  
  // MARK: - Selector Methods
  
  @objc private func cancelPressed() {
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.resetInputFields()
    }
  }
  
  @objc private func donePressed() {
    guard let title = inputTaskTextField.text,
          let priority = viewModel.getTaskPriority(for: prioritySegementedControl.selectedSegmentIndex) else { return }

    taskSubject.onNext(Task(title: title, priority: priority))
    
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.resetInputFields()
    }
  }
  
  @objc private func handleTextField() {
    guard let inputTaskFieldIsReallyEmpty = inputTaskTextField.text?.isReallyEmpty else {
      return
    }
    doneButton.isEnabled = !inputTaskFieldIsReallyEmpty
  }
}

// MARK: - UITextFieldDelegate

extension AddTaskViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

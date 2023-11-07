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
  
  private let cancelButton = ModalNavBarButton(title: "Cancel")
  
  private let doneButton = ModalNavBarButton(title: "Done")
  
  private let taskPriorityControl: UISegmentedControl
  
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
    taskPriorityControl = UISegmentedControl(items: viewModel.getSegementedControlTitles())
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
    
    cancelButton.action = { [weak self] in
      self?.cancelPressed()
    }
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    doneButton.isEnabled = false
    doneButton.action = { [weak self] in
      self?.donePressed()
    }
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    taskPriorityControl.backgroundColor = .systemGray5
    taskPriorityControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
    taskPriorityControl.resetSelectedSegmentToFirstIndex()
    taskPriorityControl.translatesAutoresizingMaskIntoConstraints = false
    
    inputTaskTextField.delegate = self
    inputTaskTextField.addTarget(self,action: #selector(validateTextField), for: .editingChanged)

    view.addSubview(cancelButton)
    view.addSubview(doneButton)
    view.addSubview(taskPriorityControl)
    view.addSubview(inputTaskTextField)

    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
      
      doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
      
      taskPriorityControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      taskPriorityControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      inputTaskTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70),
      inputTaskTextField.heightAnchor.constraint(equalTo: inputTaskTextField.widthAnchor, multiplier: 0.10),
      inputTaskTextField.topAnchor.constraint(equalTo: taskPriorityControl.bottomAnchor, constant: 15),
      inputTaskTextField.centerXAnchor.constraint(equalTo: taskPriorityControl.centerXAnchor),
    ])
  }
  
  // MARK: - Helper Methods
  private func resetInputFields() {
    inputTaskTextField.text = ""
    doneButton.isEnabled = false
  }

  private func cancelPressed() {
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.resetInputFields()
    }
  }

  private func donePressed() {
    guard let title = inputTaskTextField.text,
          let priority = viewModel.getTaskPriority(for: taskPriorityControl.selectedSegmentIndex) else { return }

    taskSubject.onNext(Task(title: title, priority: priority))
    
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.resetInputFields()
    }
  }
  
  @objc private func validateTextField() {
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

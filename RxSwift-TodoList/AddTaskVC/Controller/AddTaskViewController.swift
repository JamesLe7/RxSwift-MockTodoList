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
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewControllerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Task"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.isEnabled = false
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let prioritySegementedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["High","Medium","Low"])
        segmentedControl.backgroundColor = .systemGray5
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
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
        textField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helper Methods

    private func configureUI() {
        configureTopButtons()
        configureViewControllerLabel()
        configureViewController()
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
    
    private func configureViewControllerLabel() {
        view.addSubview(viewControllerLabel)
        viewControllerLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        viewControllerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configureViewController() {
        title = "Add Task"
        view.backgroundColor = .white
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
        if let title = inputTaskTextField.text, let priority = TaskPriority(rawValue: prioritySegementedControl.selectedSegmentIndex) {

            let task = Task(title: title, priority: priority)
            taskSubject.onNext(task)
            
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.resetInputFields()
            }
        }
    }
    
    @objc private func handleTextField() {
        if let inputTaskFieldIsReallyEmpty = inputTaskTextField.text?.isReallyEmpty {
            doneButton.isEnabled = !inputTaskFieldIsReallyEmpty
        }
    }
}

// MARK: - UITextFieldDelegate

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

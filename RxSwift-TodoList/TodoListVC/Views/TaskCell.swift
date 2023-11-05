//
//  TaskCell.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/17/20.
//

import UIKit

final class TaskCell: UITableViewCell {
  static let reuseIdentifier = "TaskCell"
  
  // MARK: - Properties
  
  private let taskTitleLabel = UILabel()
  
  var title: String? {
    didSet {
      taskTitleLabel.text = title
    }
  }
  
  // MARK: - Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    taskTitleLabel.textColor = .black
    taskTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(taskTitleLabel)
    
    NSLayoutConstraint.activate([
      taskTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      taskTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      taskTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      taskTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

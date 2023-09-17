//
//  TaskListTableViewHeader.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/18/20.
//

import UIKit

class TaskListTableViewHeader: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
      
      backgroundColor = .systemGray5
      addSubview(titleLabel)
      
      NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
      ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

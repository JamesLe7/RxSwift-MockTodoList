//
//  TaskCell.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/17/20.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: - Properties

    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        didSet {
            taskTitleLabel.text = title
        }
    }
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods

    private func configureCell() {
        addSubview(taskTitleLabel)
        taskTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        taskTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}

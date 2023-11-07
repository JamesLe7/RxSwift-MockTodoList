//
//  CancelButton.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/5/23.
//

import UIKit

final class ModalNavBarButton: UIView {
  
  private let title: String
  private let button = UIButton(type: .system)
  var action: () -> Void
  
  var isEnabled: Bool {
    didSet {
      button.isEnabled = isEnabled
    }
  }
  
  init(title: String, action: @escaping() -> Void = {}) {
    self.title = title
    self.action = action
    isEnabled = true
    super.init(frame: .zero)

    button.setTitle(title, for: .normal)
    button.tintColor = .systemRed
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(button)
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: leadingAnchor),
      button.topAnchor.constraint(equalTo: topAnchor),
      button.trailingAnchor.constraint(equalTo: trailingAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func buttonPressed() {
    action()
  }
}

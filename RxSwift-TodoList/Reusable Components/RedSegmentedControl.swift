//
//  RedSegmentedControl.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/6/23.
//

import UIKit

final class RedSegmentedControl: UIView {

  private let segmentedControl: UISegmentedControl
  var valuedChangedAction: () -> Void
  
  var segmentSelected: Int {
    get { segmentedControl.selectedSegmentIndex }
  }

  init(items: [Any], valuedChangedAction: @escaping() -> Void = {}) {
    segmentedControl = UISegmentedControl(items: items)
    self.valuedChangedAction = valuedChangedAction
    super.init(frame: .zero)

    segmentedControl.backgroundColor = .systemGray5
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemRed], for: .normal)
    segmentedControl.resetSelectedSegmentToFirstIndex()
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    addSubview(segmentedControl)

    NSLayoutConstraint.activate([
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
      segmentedControl.topAnchor.constraint(equalTo: topAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
      segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func controlValueChanged() {
    valuedChangedAction()
  }
}

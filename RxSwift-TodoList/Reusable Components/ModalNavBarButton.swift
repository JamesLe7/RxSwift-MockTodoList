//
//  CancelButton.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 11/5/23.
//

import UIKit

final class ModalNavBarButton: UIButton {
  
  private let title: String
  
  init(title: String) {
    self.title = title
    super.init(frame: .zero)
    
    setTitle(title, for: .normal)
    setTitleColor(.systemRed, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

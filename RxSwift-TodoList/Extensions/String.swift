//
//  String+IsReallyEmpty.swift
//  RxSwift-TodoList
//
//  Created by James Ledesma on 3/8/21.
//

import UIKit

extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

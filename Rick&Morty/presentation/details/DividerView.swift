//
//  DividerView.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation
import UIKit

class DividerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .systemGray4
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

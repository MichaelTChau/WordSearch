//
//  LetterCell.swift
//  WordSearch
//
//  Created by Michael Chau  on 2020-05-19.
//  Copyright © 2020 Michael Chau . All rights reserved.
//

import UIKit

class LetterCell : UICollectionViewCell {
    private let label: UILabel = UILabel()
    
    // MARK: UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setLetter(char: String) {
        let width = self.frame.width
        label.text = char
        label.sizeToFit()
        label.center = CGPoint(x: width / 2,
                               y: width / 2)
    }
    
    private func setupView() {
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unused")
    }
}

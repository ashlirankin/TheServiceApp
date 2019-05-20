//
//  IBDesignableViews.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

@IBDesignable
class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
//        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

@IBDesignable
class RoundedImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = 12.0
//        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

@IBDesignable
class RoundedTextButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtonUI()
    }
    private func setupButtonUI() {
        backgroundColor = #colorLiteral(red: 0.2461647391, green: 0.3439296186, blue: 0.5816915631, alpha: 1)
        layer.cornerRadius = self.frame.height / 2
        setTitleColor(.white, for: .normal)
        
        layer.shadowColor = #colorLiteral(red: 0.2461647391, green: 0.3439296186, blue: 0.5816915631, alpha: 1).cgColor
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func buttonSelectedUI() {
        backgroundColor = #colorLiteral(red: 0, green: 0.5772375464, blue: 0.5888287425, alpha: 1)
        layer.shadowColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
        tintColor = .clear
        setTitleColor(.white, for: .normal)
    }
    
    func buttonDeselectedUI() {
        backgroundColor = #colorLiteral(red: 0.2461647391, green: 0.3439296186, blue: 0.5816915631, alpha: 1)
        layer.shadowColor = UIColor.black.cgColor
        setTitleColor(.white, for: .normal)
    }
}


@IBDesignable
class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

@IBDesignable
class CornerImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

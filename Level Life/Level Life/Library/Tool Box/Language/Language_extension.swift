//
//  Language_extension.swift
//  LanguageTools
//
//  Created by 黄穆斌 on 2017/6/20.
//  Copyright © 2017年 myron. All rights reserved.
//

import UIKit

/** 获取本地化语言 */
func localized(_ key: String) -> String {
    return Language.standard.get(key: key)
}

// MARK: - Extension String

extension String {
    
    var language: String {
        return Language.standard.get(key: self)
    }
    
}

// MARK: - Extension UIView

extension UIView {
    
    func language() {
        if let label = self as? UILabel {
            label.text = label.text?.language
        }
        else if let textField = self as? UITextField {
            textField.placeholder = textField.placeholder?.language
        }
        else if let button = self as? UIButton {
            for status in [UIControlState.normal, UIControlState.selected, UIControlState.highlighted, UIControlState.disabled] {
                button.setTitle(button.title(for: status), for: status)
            }
        }
        else if let segment = self as? UISegmentedControl {
            for i in 0 ..< segment.numberOfSegments {
                segment.setTitle(segment.titleForSegment(at: i)?.language, forSegmentAt: i)
            }
        }
        
        for subview in subviews {
            subview.language()
        }
    }
    
}

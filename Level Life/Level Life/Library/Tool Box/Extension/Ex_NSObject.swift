//
//  Ex_NSObject.swift
//  Level Life
//
//  Created by Myron on 2017/11/21.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

extension NSObject {
    
    func print(_ message: String, file: String = #file, function: String = #function) {
        Swift.print("\(file.components(separatedBy: ["/"]).last ?? "")/\(function): \(message)")
    }
    
    func print_message(_ message: String) {
        Swift.print(message)
    }
    
    func print_block(tag: String = "", file: String = #file, function: String = #function, _ block: ((String) -> Void) -> Void) {
        Swift.print("============== S \(tag) S \(file.components(separatedBy: ["/"]).last ?? "")/\(function) ===")
        block(print_message)
        Swift.print("============== E \(tag) E ==============")
    }
    
}

//
//  Language_input.swift
//  LanguageTools
//
//  Created by 黄穆斌 on 2017/6/20.
//  Copyright © 2017年 myron. All rights reserved.
//

import Foundation

extension Language {
    
    /** Input the languages, must call the reload */
    func libray_input() {
        let input = InputTool(types: ["en", "ch", "CH"])
        
        input
        .add(["Success", "成功", "成功"])
        .add(["Error", "错误", "錯誤"])
        .add(["Loading", "加载中", "加載中"])
        
        reload(values: input.output())
    }
    
}

//
//  Language.swift
//  LanguageTools
//
//  Created by 黄穆斌 on 2017/6/20.
//  Copyright © 2017年 myron. All rights reserved.
//

import Foundation

// MARK: - Language

/**
 iOS language localized plan.
 */
class Language {
    
    /** Singleton. */
    static var standard: Language = Language()
    private init() {
        language_type = Language.system()
        libray_input()
    }
    
    /** Language library. */
    fileprivate var language_libraries: [String: [String: String]] = [:]
    /** Current language type. */
    fileprivate var language_type: String = "en"
    
}

// MARK: - Language Libray Get Set

extension Language {
    
    /** Reload datas */
    func reload(values: [String: [String: String]]) {
        language_libraries = values
    }
    
    /** Add data */
    func add(key: String, value: [String: String]) {
        language_libraries[key] = value
    }
    
    /** Get text */
    func get(key: String) -> String {
        return language_libraries[key]?[language_type] ?? key
    }
    
    /** Get text */
    subscript(key: String) -> String {
        return language_libraries[key]?[language_type] ?? key
    }
    
    /** update current */
    func update(language_type: String) {
        Language.standard.update(language_type: language_type)
        self.language_type = language_type
    }
    
}

// MARK: - Language Sub Class ...

extension Language {
    
    /** Language State */
    enum State: String {
        case English = "en"
        case Chinese = "ch"
        case Chinese_traditional = "CH"
        case Japanese = "ja"
    }
    
    /** Input tool to easy. */
    class InputTool {
        
        /** language types */
        let language_types: [String]
        /** some values to language. must match the language type. */
        var language_values: [[String]] = []
        
        init(types: [String]) {
            language_types = types
        }
        
        /** Add values */
        @discardableResult
        func add(_ values: [String]) -> InputTool {
            language_values.append(values)
            return self
        }
        
        /** Output */
        func output() -> [String: [String: String]] {
            var library = [String: [String: String]]()
            
            // Checks
            if language_types.count == 0 {
                return library
            }
            
            /*
            // Get the keys
            var key_indexs = [0]
            for (index, type) in language_types.enumerated() {
                if index != 0 && (type == "en" || type == "ch") {
                    key_indexs.append(index)
                }
            }
            */
            
            // Set values
            for values in language_values {
                if values.count == 0 {
                    continue
                }
                for key_index in 0 ..< language_types.count {
                    let key = values[key_index]
                    var languages = [String: String]()
                    for (index, type) in language_types.enumerated() {
                        if index < values.count {
                            languages[type] = values[index]
                        }
                        else {
                            languages[type] = values[0]
                        }
                    }
                    library[key] = languages
                }
            }
            
            return library
        }
    }
    
}

// MARK: - Language Tools

extension Language {
    
    /** 
     Get the current system language.
     en: English
     ch: Chinese
     CH: Chinese traditional
     ja: Japanese
     */
    class func system() -> String {
        let apple_languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        //print("Language system = (\(languages?.first ?? "Error"));")
        let language = apple_languages?.first ?? "en"
        if language.hasPrefix("zh-Hans") {
            return State.Chinese.rawValue
        }
        else if language.hasPrefix("zh-Hant") {
            return State.Chinese_traditional.rawValue
        }
        else if language.hasPrefix("ja") {
            return State.Japanese.rawValue
        }
        else {
            return State.English.rawValue
        }
    }
    
}

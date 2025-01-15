//
//  PhoneCountryFormatter.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import Foundation

class PhoneCountryFormatter: Formatter {
    private var pattern: String = ""

    init(pattern: String = "### ### ###") {
        super.init()
        self.pattern = pattern
    }
    
    // Required initializer for NSCoder compliance
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return applyPatternOnNumbers(string, pattern: self.pattern, replacementCharacter: "#")
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
         obj?.pointee = string as AnyObject?
         return true
     }
    
    func applyPatternOnNumbers(_ stringvar: String, pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                return pureNumber
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
}

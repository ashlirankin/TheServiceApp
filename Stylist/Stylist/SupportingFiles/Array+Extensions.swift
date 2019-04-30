//
//  Array+Extensions.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/23/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

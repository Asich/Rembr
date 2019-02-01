//
//  Collection+Extension.swift
//  MyBeeline
//
//  Created by Askar Mustafin on 3/6/18.
//  Copyright © 2018 VEON LTD. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    public func jsonString() -> String? {
        var theJSONData : Data
        do {
            theJSONData = try JSONSerialization.data(withJSONObject: self)
            return String(data: theJSONData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

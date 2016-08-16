//
//  StringExtensions.swift
//  simplemath
//
//  Created by Vineeth Vijayan on 14/08/16.
//  Copyright © 2016 creativelogics. All rights reserved.
//

import Foundation

extension String{
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
}

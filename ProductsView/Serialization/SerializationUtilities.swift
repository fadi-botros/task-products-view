//
//  SerializationUtilities.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import Foundation

struct SerializationUtilities {
    
    /// Number formatter to be used, this is a variable you can set if you want, this value
    ///     is just an initial value.
    static var numberFormatter: NumberFormatter = {
        let ret = NumberFormatter()
        ret.allowsFloats = true
        ret.locale = Locale(identifier: "en")
        return ret
    }()
    
    /// Gets string from a dictionary resulting typically from
    ///     `JSONSerialization.jsonObject(with:, options:)`
    ///
    /// - Parameters:
    ///   - dictionary: The dictionary to get from
    ///   - key: The key to get the string from
    /// - Returns: String from the dictionary with this key, if not string, try to get its describing
    ///       string
    static func string(from dictionary: NSDictionary, for key: String) -> String? {
        if let val = dictionary[key] { return String(describing: val) } else { return nil }
    }

    /// Gets a number from a dictionary resulting typically from
    ///     `JSONSerialization.jsonObject(with:, options:)`
    ///
    /// - Parameters:
    ///   - dictionary: The dictionary to get from
    ///   - key: The key to get a number from
    /// - Returns: Number from the dictionary with this key, if the value was String, try to parse it
    static func number(from dictionary: NSDictionary, for key: String) -> NSNumber? {
        let value = dictionary[key]
        // Can be cast directly?
        if let ret = value as? NSNumber {
            return ret
        }
        // Can't? may be a string, or something can be expressed as string
        if let str = string(from: dictionary, for: key) {
            return SerializationUtilities.numberFormatter.number(from: str)
        }
        return nil
    }
}

//
//  SumSequence.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/18/22.
//

import Foundation

extension Sequence {
    func sum<T: Numeric>(for keyPath: KeyPath<Element, T>) -> T {
        return reduce(0) { sum, element in
            sum + element[keyPath: keyPath]
        }
    }
}

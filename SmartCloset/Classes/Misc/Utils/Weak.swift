//
//  Weak.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

final class Weak<T> {
    weak private var value: AnyObject?
    
    var weak: T? {
        return value as? T
    }
    
    init<T: AnyObject>(_ value: T) {
        self.value = value
    }
}

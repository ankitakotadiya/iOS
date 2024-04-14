//
//  Message.swift
//  Generics
//
//  Created by Ankita Kotadiya on 14/04/24.
//

import Foundation
import Combine



class Messaging {
    // Dictionary to store PassthroughSubjects for each event type
    private var subjectMap: [String: PassthroughSubject<Any, Never>] = [:]

    // Method to publish an event with associated data
    func publish<T>(event: String, data: T) {
        if let subject = subjectMap[event] {
            subject.send(data)
        }
    }

    // Method to subscribe to events of a specific type
    func subscribe<T>(to event: String, handler: @escaping (T) -> Void) -> AnyCancellable {
        if subjectMap[event] == nil {
            subjectMap[event] = PassthroughSubject<Any, Never>()
        }

        return subjectMap[event]!.sink { data in
            if let typedData = data as? T {
                handler(typedData)
            }
        }
    }
}

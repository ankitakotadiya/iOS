//
//  StoryBoard.swift
//  CarviOSTask
//
//  Created by Ankita Kotadiya on 30/07/23.
//

import Foundation
import UIKit

protocol Storyboard {
    static func instantiate() -> Self
}

extension Storyboard where Self: UIViewController {
    static func instantiate() -> Self {

        // this splits by the dot and uses everything after, giving "ViewController"
        let className = String.className(for: Self.self)

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension String {
    static func className(for classType: AnyClass) -> String {
        return String(describing: classType)
    }
}

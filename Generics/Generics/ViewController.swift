//
//  ViewController.swift
//  Generics
//
//  Created by Ankita Kotadiya on 14/04/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        main()
    }
    
    
    func main() {
        let messaging = Messaging()
        
        // Subscribe to String events
        let stringSubscriber = messaging.subscribe(to: "StringEvent") { (str: String) in
            print("Received String event with data: \(str)")
        }
        
        // Subscribe to Float events
        let floatSubscriber = messaging.subscribe(to: "FloatEvent") { (num: Double) in
            print("Received Float event with data: \(num)")
        }
        
        // Publish String events
        messaging.publish(event: "StringEvent", data: "Hello")
        
        // Publish Float events
        messaging.publish(event: "FloatEvent", data: 3.14)
        
        // Clean up the subscriptions
        stringSubscriber.cancel()
        floatSubscriber.cancel()
    }

}


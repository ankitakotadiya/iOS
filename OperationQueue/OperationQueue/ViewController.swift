//
//  ViewController.swift
//  OperationQueue
//
//  Created by Ankita Kotadiya on 22/05/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var imagArr: [String] = ["https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
    "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"]
    var downloadedImg: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.asyncOperation()
        print("Images Downloaded")
    }
    
    // This is not something that we want it will execute tasks in main thread how can we took it from main thread
    func startOperation() {
        print("Image downloading started")
        let operation: BlockOperation = BlockOperation()
        
        operation.addExecutionBlock {
            for strImg in self.imagArr {
                
                self.DownloadImage(url: strImg) { data in
                    self.downloadedImg.append(data)
                    print("Image Completed",self.downloadedImg.count)
                    print("Main Thread completion block",Thread.isMainThread) // this is async task so seperate thread
                }
            }
            print("Main Thread inside operation",Thread.isMainThread) // same main thread
        }
        print("Main Thread operation start",Thread.isMainThread) //It will execute in main thread
        operation.start() // main thread
    }
    
    // and here we can see it has took it from main thread so tasks will work concurrently on seperate thread.
    func asyncOperation() {
        let operationQueue: OperationQueue = OperationQueue()
        
        let operations: BlockOperation = BlockOperation()
        operations.addExecutionBlock {
            for strImg in self.imagArr {
                
                self.DownloadImage(url: strImg) { data in
                    self.downloadedImg.append(data)
                    print("Image Completed",self.downloadedImg.count)
                    print("Main Thread completion block",Thread.isMainThread) // this is async task so seperate thread
                }
            }
            print("Main Thread inside operation block", Thread.isMainThread)
        }
        print("Main Thread operation start", Thread.isMainThread)
        operationQueue.addOperation(operations)
    }
    
    private func DownloadImage(url: String, completion: @escaping(Data) -> Void) {
        guard let urlString = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlString)) { data, response, error in
            
            if let responseData  = data {
                completion(responseData)
            }
        }
        task.resume()
    }
}



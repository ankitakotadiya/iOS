//
//  OperationQueueDependencyViewController.swift
//  OperationQueue
//
//  Created by Ankita Kotadiya on 22/05/24.
//

import UIKit

class OperationQueueDependencyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startOperation()
    }
    
    private func startOperation() {
        let operationQueue: OperationQueue = OperationQueue()
        
        let operation1: APIOperation = APIOperation { [weak self] completion in
            self?.performApiCall1(completion: completion)
        }
        
        let operation2: APIOperation = APIOperation { [weak self] completion in
            self?.performApiCall2(completion: completion)
        }
        
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    private func performApiCall1(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            print("API 1 Called")
            completion()
        }
    }
    
    private func performApiCall2(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            print("API 2 Called")
            completion()
        }
    }
}

class APIOperation: AsyncOperation {
    let apiCall: (_ completion: @escaping () -> Void) -> Void
    
    init(apiCall: @escaping (_ completion: @escaping () -> Void) -> Void) {
        self.apiCall = apiCall
        super.init()
    }
    
    override func main() {
        self.apiCall {
            self.finish()
        }
    }
}

class AsyncOperation: Operation {
    override var isAsynchronous: Bool { return true }
    
    private var _executing: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        main()
    }
    
    override func main() {
        fatalError("Subclasses must implement `main`.")
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}

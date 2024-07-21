//
//  RaceConditionViewController.swift
//  API-Race-Test
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import UIKit

class RaceConditionViewController: UIViewController {
    
    private let flight: Flight = Flight()
    private let flightBooking: FlightBooking = FlightBooking()
    private let semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Using Priority Queue but it is temporary fix
        //        DispatchQueue.global(qos: .userInteractive).async {
        //            let seat = self.flight.bookSeat()
        //            print("Booked Seat: \(seat)")
        //        }
        //        DispatchQueue.global(qos: .background).async {
        //            let availableSeats = self.flight.getAllAvailableSeats()
        //            print("Available Seats: \(availableSeats)")
        //        }
        
        //2. Dispatch Semaphore
        //        self.semaphore.wait()
        //        DispatchQueue.global(qos: .userInteractive).async {
        //            let seat = self.flight.bookSeat()
        //            print("Booked Seat: \(seat)")
        //            self.semaphore.signal()
        //        }
        //
        //        self.semaphore.wait()
        //        DispatchQueue.global(qos: .background).async {
        //            let availableSeats = self.flight.getAllAvailableSeats()
        //            print("Available Seats: \(availableSeats)")
        //            self.semaphore.signal()
        //        }
        
        //3. Dispatch Barrier
        //        DispatchQueue.global().async {
        //            let seat = self.flight.bookSeat()
        //            print("Booked Seat: \(seat)")
        //        }
        //        DispatchQueue.global().async {
        //            let availableSeats = self.flight.getAllAvailableSeats()
        //            print("Available Seats: \(availableSeats)")
        //        }
        
        //4. Actor
        Task {
            let seat = await self.flightBooking.bookSeat()
            print("Booked Seat: \(seat)")
        }
        Task {
            let availableSeats = await self.flightBooking.getAllAvailableSeats()
            print("Available Seats: \(availableSeats)")
        }
        Task {
            let availableSeats = await self.flightBooking.getAllAvailableSeats()
            print("Available Seats: \(availableSeats)")
        }
    }
}

actor FlightBooking {
    var availableSeats = ["1A","1B","1C"]
    
    func getAllAvailableSeats() -> [String] {
        return availableSeats
    }
    
    func bookSeat() -> String {
        let seat = self.availableSeats.removeFirst()
        return seat
    }
}

class Flight {
    var availableSeats = ["1A","1B","1C"]
    let barrierQueue = DispatchQueue(label: "Barrier Queue", attributes: .concurrent)
    
    func getAllAvailableSeats() -> [String] {
        barrierQueue.sync(flags: .barrier) {
            return availableSeats
        }
        
    }
    
    func bookSeat() -> String {
        barrierQueue.sync(flags: .barrier) {
            let seat = self.availableSeats.removeFirst()
            return seat
        }
    }
}

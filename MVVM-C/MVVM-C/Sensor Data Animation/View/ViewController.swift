//
//  ViewController.swift
//  CarviOSTask
//
//  Created by Ankita Kotadiya on 30/07/23.
//

import UIKit
import Combine

class ViewController: UIViewController, Storyboard{
    
    private var arrSensorData = [String]()
    
    var viewModel = SensorViewModel()
    private var sensorPadView:SensorPadView?
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ConfigureMainView()
        
        //Test Problem 2
        self.appendSensorData()
        self.addSensorPadView()
        
    }
    
    func ConfigureMainView() {
        self.title = "Sensor Screen"
    }
    
    //Problem 1
    func appendSensorData() {
        
        let csvData = viewModel.readCSVData()
        for row in csvData {
            arrSensorData.append(row)
        }
    }
    
    func addSensorPadView() {
        sensorPadView = SensorPadView(data: arrSensorData)
        
        if let sensorView = sensorPadView {
            view.addSubview(sensorView)
            
            // Set constraints for the SensorPadView
            sensorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sensorView.widthAnchor.constraint(equalTo: view.widthAnchor),
                sensorView.heightAnchor.constraint(equalTo: view.heightAnchor),
                sensorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                sensorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                sensorView.topAnchor.constraint(equalTo: view.topAnchor),
                sensorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}


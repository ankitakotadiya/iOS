//
//  SensorViewModel.swift
//  CarviOSTask
//
//  Created by Ankita Kotadiya on 30/07/23.
//

import Foundation

class SensorViewModel {
    
    
    func readCSVData() -> [String] {
        
        var arrData = [String]()
        guard let fileURL = Bundle.main.url(forResource: "sensor_data", withExtension: "csv") else {
            return ["No data Found"]
        }
        
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            
            let rows = contents.components(separatedBy: .newlines)
            
            // Assuming the header row contains column names separated by commas.
            let headers = rows.first?.components(separatedBy: ",").joined(separator: ",")
            
            
            arrData = rows.filter { !$0.isEmpty && $0 != headers }
            
        } catch {
            print("Error reading CSV file: \(error)")
        }
        
        return arrData
    }
    
}

//
//  FileStoreManager.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 27/10/24.
//

import Foundation
import UIKit

class FileStoreManager {
    private let fileManager = FileManager.default
    private let imageDirectoryURL: URL
    private let maxDirectorySize: Int64 = 10 * 1024 * 1024 // 10 MB
    
    init() {
        let documentURl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.imageDirectoryURL = documentURl.appendingPathComponent("Images")
        
        if !fileManager.fileExists(atPath: imageDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: imageDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Not able to create folder")
            }
        }
    }
    
    func saveImageToDisk(for data: Data, identifier: String) {
        let imageURL = imageDirectoryURL.appendingPathComponent(identifier)
        
        do {
            try data.write(to: imageURL)
        } catch {
            fatalError("Not able to save data")
        }
    }
    
    func getImageData(with identifier: String) -> Data? {
        let imageURL = imageDirectoryURL.appendingPathComponent(identifier)
        
        do {
            return try Data(contentsOf: imageURL)
        } catch {
            return nil
        }
    }
    
    private func hasEnoughDiskSpace(for newData: Data) -> Bool {
        let currentSize = totalSizeOfFiles()
        let newSize = currentSize + Int64(newData.count)
        return newSize <= maxDirectorySize
    }
    
    private func totalSizeOfFiles() -> Int64 {
        do {
            let files = try fileManager.contentsOfDirectory(at: imageDirectoryURL, includingPropertiesForKeys: nil)
            let totalSize = files.reduce(0) { (total: Int64, fileURL: URL) in
                (total + (try! fileManager.attributesOfItem(atPath: fileURL.path)[.size] as? Int64 ?? 0))
            }
            return totalSize
        } catch {
            print("Error calculating total size of files: \(error)")
            return 0
        }
    }
    
    private func cleanUpDiskSpace() {
        do {
            let files = try fileManager.contentsOfDirectory(at: imageDirectoryURL, includingPropertiesForKeys: nil)
            
            // Sort files by creation date
            let sortedFiles = files.sorted {
                let attributes1 = try? fileManager.attributesOfItem(atPath: $0.path)
                let attributes2 = try? fileManager.attributesOfItem(atPath: $1.path)
                
                let date1 = attributes1?[.creationDate] as? Date ?? Date()
                let date2 = attributes2?[.creationDate] as? Date ?? Date()
                
                return date1 < date2
            }
            
            // Delete files until we are below the max directory size
            var totalSize = totalSizeOfFiles()
            for fileURL in sortedFiles {
                if totalSize <= maxDirectorySize {
                    break
                }
                do {
                    let fileSize = try fileManager.attributesOfItem(atPath: fileURL.path)[.size] as? Int64 ?? 0
                    try fileManager.removeItem(at: fileURL)
                    totalSize -= fileSize
                } catch {
                    print("Error deleting file: \(error)")
                }
            }
        } catch {
            print("Error during cleanup: \(error)")
        }
    }
}

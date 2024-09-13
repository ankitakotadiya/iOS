//
import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(format: String = "dd/MM/yyyy") -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.date(from: self) ?? Date()
    }
}

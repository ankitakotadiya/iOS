//
// Copyright © 2023 ASOS. All rights reserved.
//

import Foundation

protocol DateFormatting {
	func dateAndTime(from date: Date) -> String
}

final class DefaultDateFormatter: DateFormatting {
	private let dateAndTimeFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()

	func dateAndTime(from date: Date) -> String {
		return dateAndTimeFormatter.string(from: date)
	}
}

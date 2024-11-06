//
// Copyright © 2024 ASOS. All rights reserved.
//

import Foundation
@testable import iOSCodeTest

final class MockDateFormatter: DateFormatting {
    func dateAndTime(from date: Date) -> String {
        return "05/11/2024"
    }
}

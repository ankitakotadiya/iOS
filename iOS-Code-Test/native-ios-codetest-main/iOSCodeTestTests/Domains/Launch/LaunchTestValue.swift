//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation
@testable import iOSCodeTest

extension Launch {
	static let testValue = Launch(
		name: "FalconSat",
		rocketID: "test-rocket",
		links: Links(
			patch: Links.Patch(
				small: URL(string: "image://"),
				large: nil
			)
		),
        timestamp: 1_653_321_160,
        success: true
	)
}


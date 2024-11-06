//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

struct Launch: Codable {
	enum CodingKeys: String, CodingKey {
		case name
		case rocketID = "rocket"
		case links
		case timestamp = "date_unix"
        case success
	}

	struct Links: Codable {
		struct Patch: Codable {
			var small: URL?
			var large: URL?
		}

		var patch: Patch
        var webcast: URL?
        var wikipedia: URL?
	}

	var name: String
	var rocketID: String
	var links: Links
	var timestamp: TimeInterval
    var success: Bool?
}

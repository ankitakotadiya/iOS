//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

struct Company: Codable {
	enum CodingKeys: String, CodingKey {
		case name
		case founder
		case founded
		case employees
		case launchSites = "launch_sites"
		case valuation
	}

	var name: String
	var founder: String
	var founded: Int
	var employees: Int
	var launchSites: Int
	var valuation: Int
}

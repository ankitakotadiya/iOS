//
// Copyright © 2022 ASOS. All rights reserved.
//

import UIKit

final class CompanyInfoView: UIView {
	struct ViewData: Equatable {
		var companyInfo: String
	}

	static func instantiate() -> Self {
		let nib = UINib(nibName: String(describing: self), bundle: .main)
		let objects = nib.instantiate(withOwner: nil, options: nil)
		return objects.first as! Self
	}

	@IBOutlet private var companyInfoLabel: UILabel?

	override func awakeFromNib() {
		super.awakeFromNib()
		companyInfoLabel?.accessibilityIdentifier = "companyInfo"
	}

	func configure(with viewData: ViewData) {
		companyInfoLabel?.text = viewData.companyInfo
	}
}

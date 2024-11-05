//
// Copyright © 2022 ASOS. All rights reserved.
//

import UIKit

final class LaunchSummaryView: UIView {
	struct ViewData: Equatable {
		var patchImageURL: URL?
		var missionName: String
		var date: String
		var rocketInfo: String
        var success: Bool
	}

	static func instantiate() -> Self {
		let nib = UINib(nibName: String(describing: self), bundle: .main)
		let objects = nib.instantiate(withOwner: nil, options: nil)
		return objects.first as! Self
	}

	@IBOutlet private var patchImageView: UIImageView?
	@IBOutlet private var missionNameLabel: UILabel?
	@IBOutlet private var dateLabel: UILabel?
	@IBOutlet private var rocketInfoLabel: UILabel?
    @IBOutlet private var launchImage: UIImageView?

	func configure(with viewData: ViewData) {
		if let imageView = patchImageView {
			if let imageURL = viewData.patchImageURL {
				URLSession.shared.dataTask(
					with: imageURL,
					completionHandler: { data, _, _ in
						guard let data = data, let image = UIImage(data: data) else {
							return
						}
						DispatchQueue.main.async {
							self.patchImageView?.image = image
						}
					}
				).resume()
			} else {
				imageView.image = nil
			}
		}

		missionNameLabel?.text = viewData.missionName
		dateLabel?.text = viewData.date
		rocketInfoLabel?.text = viewData.rocketInfo
        
        // Set Launch Image
        let image = viewData.success ? "checkmark" : "xmark"
        launchImage?.image = UIImage(systemName: image)
	}
}

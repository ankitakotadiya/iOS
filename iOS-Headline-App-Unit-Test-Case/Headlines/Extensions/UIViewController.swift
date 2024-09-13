import Foundation
import UIKit

extension UIViewController {
    func displayAlert(title: String? = "", message: String? = nil, actionTitle: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

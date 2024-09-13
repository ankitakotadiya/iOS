import UIKit

extension UIColor {
    
    enum Text {
        static let grey: UIColor = UIColor.grey
    }
    
    enum Background {
        static let main: UIColor = UIColor.whiteSmoke
    }
    
    enum Brand {
        static let popsicle40: UIColor = UIColor.popsicle40
    }
    
    private static let grey: UIColor = UIColor(red: 81 / 255.0, green: 81 / 255.0, blue: 83 / 255.0, alpha: 1)
    private static let popsicle40: UIColor = UIColor(red: 254 / 255.0, green: 196 / 255.0, blue: 2 / 255.0, alpha: 1)
    private static let whiteSmoke: UIColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
}

extension UIFont {
    
    enum Heading {
        static var large: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        static var medium: UIFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
        static let small: UIFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    }
    
    enum Body {
        static var mediumSemiBold: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static var medium: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static var small: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static var smallSemiBold: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}

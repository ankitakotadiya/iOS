//
//  StoryboardViewController.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import UIKit

class StoryboardViewController: UIViewController {

    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPopUp()
    }
    
    @objc private func showPopup() {
        let popupVC = ProgrameticNavigationViewController()
            popupVC.modalPresentationStyle = .custom
            popupVC.transitioningDelegate = self
            
            present(popupVC, animated: true, completion: nil)
    }
    
    func createPopUp() {
        view.addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
//        let menuinteract = UIEditMenuInteraction(delegate: self)
//        menuButton.addInteraction(menuinteract)
        
        menuButton.addAction(UIAction {_ in 
//            let config = UIEditMenuConfiguration(identifier: "Config", sourcePoint: self.menuButton.center)
//            menuinteract.presentEditMenu(with: config)
            self.showPopup()
        }, for: .touchUpInside)
        
        
        
    }
    
    func createPopUpButton() {
        let button = UIButton(type: .system)
        button.setTitle("Sort", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = createmenu()
        button.showsMenuAsPrimaryAction = true
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
        
    func createmenu() -> UIMenu {
        let option1 = UIAction(title: "Option 1") { action in
            print("Option 1 Selected")
        }
        
        let option2 = UIAction(title: "Option 2") { action in
            print("Option 3 Selected")
        }
        
        let option3 = UIAction(title: "Option 3") { action in
            print("Option 3 Selected")
        }
        
        let option4 = UIAction(title: "Option 4") { action in
            print("Option 4 Selected")
        }
        
        return UIMenu(title: "Choose an Option", options: .destructive, children: [option1, option2, option3, option4])
        
        // Present the menu as a popover
    }

}

extension StoryboardViewController: UIEditMenuInteractionDelegate {
    
//    func editMenuInteraction(_ interaction: UIEditMenuInteraction, configurationForMenuAt location: CGPoint) -> UIEditMenuConfiguration? {
//        // Create the menu configuration
//        let menuConfig = UIEditMenuConfiguration(identifier: "menuConfig", sourcePoint: location)
//        return menuConfig
//    }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        return createmenu()
    }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, targetRectFor configuration: UIEditMenuConfiguration) -> CGRect {
        return .init(origin: .init(x: menuButton.frame.width / 2, y: 0), size: .zero)
    }
}

extension StoryboardViewController: UIViewControllerTransitioningDelegate {
    
}

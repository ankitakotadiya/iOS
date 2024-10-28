//
//  ViewController.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFooter: UIButton!
    private var rows: Int = 10
    private var selectedIndexPath = Set<IndexPath>()
    private var _isEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocalStorage.shared.setUserID.isEmpty {
            LocalStorage.shared.setUserID = "ANK1317"
        } else {
            title = LocalStorage.shared.setUserID
            saveUser()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(selectButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Navigate", style: .plain, target: self, action: #selector(navigateToVC))
        configureTableview()
//        LocalStorage.shared.setUserID = "ANK1317"
    }
    
    
    @objc func navigateToVC() {
        self.navigateFromStoryBoard()
//        presentDatePicker()
    }
    
    func saveUser() {
        Task {
            let user = User(context: DataBaseManager.shared.viewContext)
            user.name = "Ankita"
            
            do {
                try await DataBaseManager.shared.saveContext()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        let users = DataBaseManager.shared.fetch(type: User.self)
        print(users.first?.name)
    }
    
    @objc func selectButtonTapped() {
        
        if navigationItem.rightBarButtonItem?.title == "Select" {
            _isEditing = true
        } else {
            _isEditing = false
        }
        
        navigationItem.rightBarButtonItem?.title = _isEditing ? "Cancel" : "Select"
        tableView.setEditing(_isEditing, animated: true)
        hideShowFooterButton()
    }
    
    private func configureTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 99
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelectionDuringEditing = true
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TestTableViewCell.self))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
//        tableView.tableFooterView = TableFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        btnFooter.isHidden = true
    }
    
    func presentDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.maximumDate = Date()
        
        let datePickerVC = UIViewController()
        datePickerVC.view.addSubview(datePicker)
        datePickerVC.modalPresentationStyle = .popover
        
        let sourceView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        if let popver = datePickerVC.popoverPresentationController {
            popver.sourceView = sourceView
            popver.sourceRect = sourceView.frame
            popver.permittedArrowDirections = .any
            popver.delegate = self
        }
        present(datePickerVC, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        fetchData()
    }

    func getInitials(from name: String) -> String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    func navigateToNext() {
        let next: NextViewController = self._instantiateViewControllerFromXIB()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func navigateFromStoryBoard() {
        let story: StoryboardViewController = self._instantiateViewControllerFromStoryBoard()
        self.navigationController?.pushViewController(story, animated: true)
    }
    
    func programeticNavigation() {
        let vc = ProgrameticNavigationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hideShowFooterButton() {
        btnFooter.setTitle("\(selectedIndexPath.count) Row(s) Selected", for: .normal)
        
        if _isEditing && selectedIndexPath.count > 0 {
            btnFooter.isHidden = false
        } else {
            btnFooter.isHidden = true
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TestTableViewCell.self)) as? TestTableViewCell else {
            return UITableViewCell()
        }
        
//        var config = cell.defaultContentConfiguration()
//        config.text = "Test"
//        config.secondaryText = "Sub Test"
//        config.image = UIImage(systemName: "star.fill")
//        cell.contentConfiguration = config
        
        cell.imgView.image = UIImage(systemName: "star.fill")
        cell.lblTitle.text = "Test"
        cell.lblSubtitle.text = "Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger. <NSLayoutConstraint:0x600002130410 'UIView-Encapsulated-Layout-Height"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableHeaderFooterView().loadNib()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completion in
            self.rows-=1
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath.contains(indexPath) {
            selectedIndexPath.remove(indexPath)
        } else {
            selectedIndexPath.insert(indexPath)
        }
        hideShowFooterButton()
//        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath.remove(indexPath)
        hideShowFooterButton()
//        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = TableFooterView()
        footer.loadMoreButton.setTitle("\(selectedIndexPath.count) Row(s) Selected", for: .normal)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if _isEditing && selectedIndexPath.count > 0 {
            return 60
        } else {
            return 0
        }
    }
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


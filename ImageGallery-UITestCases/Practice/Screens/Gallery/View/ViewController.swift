//
//  ViewController.swift
//  Practice
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import UIKit
import Combine
import PhotosUI

final class ViewController: UIViewController {

    private let viewModel: GalleryViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .white
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.accessibilityIdentifier = "ImageTableView"
        return tableview
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemMint
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Select Images", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Gallery"
        setupView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$gallery.sink { [weak self] _ in
            self?.updateUI()
        }.store(in: &cancellable)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController {
    private func setupView() {
        view.backgroundColor = .white
        view._addsubViews(selectButton, tableView)
        selectButton.addAction(UIAction { _ in
            self.selectButtonTapped()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 45),
            
            tableView.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 195
        tableView.rowHeight = UITableView.automaticDimension
        tableView._registerTableviewCellwithIdentifier(GalleryTableViewCell.self)
    }
    
    private func selectButtonTapped() {
//        presentImagePickerViewController()
        presentPHPPickerViewController()
    }
    
    private func presentImagePickerViewController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    private func presentPHPPickerViewController() {
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 0
        configure.filter = .images
        
        let picker = PHPickerViewController(configuration: configure)
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gallery.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GalleryTableViewCell = tableView._dequeReusableCellWithIdentifier()
        
        let item = viewModel.gallery[indexPath.row]
        cell.configure(for: item)
        
        return cell
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage, let imgData = selectedImage.pngData() {
            let gallery = Gallery(image: imgData, description: "This image is about the nature and find data regadinging")
            viewModel.gallery.append(gallery)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                let progress = result.itemProvider.loadDataRepresentation(for: UTType.image) { [weak self] imgData, error in
                    guard let self = self, let data = imgData, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        let randomNumber = Int.random(in: 0..<5)
                        let gallery = Gallery(image: data, description: self.viewModel.descriptions[randomNumber])
                        self.viewModel.gallery.append(gallery)
                    }
                }
            }
        }
    }
}


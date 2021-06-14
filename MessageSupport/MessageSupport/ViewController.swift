//
//  ViewController.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var attachmentsCollectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var presenter: SupportMessagePresenterProtocol?
    let messageTextViewPlaceHolder = "Enter your message"
    var photos = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.attachmentsCollectionView.reloadData()
            }
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMessageTextView()
        setUpattachmentsCollectionView()
        
        presenter = MessageSupportPresenter()
        presenter?.view = self
        presenter?.model = MessageSupportModel()
        
        presenter?.viewDidLoad()
    }
    // MARK: - Methods
    private func setUpMessageTextView() {
        messageTextView.delegate = self
        messageTextView.text = messageTextViewPlaceHolder
        messageTextView.textColor = UIColor.lightGray
    }
    private func setUpattachmentsCollectionView() {
        attachmentsCollectionView.dataSource = self
        attachmentsCollectionView.delegate = self
        attachmentsCollectionView.register(ImageCollectionViewCell.nib,
                                           forCellWithReuseIdentifier: ImageCollectionViewCell.identifire)
    }
    // MARK: - IBAction
    @IBAction func chooseCategory(_ sender: UITapGestureRecognizer) {
        presenter?.getAllCategories()
    }
    
    @IBAction func chooseSubcategory(_ sender: UITapGestureRecognizer) {
        presenter?.getSubCategories()
    }
    
    @IBAction func attachImages(_ sender: UITapGestureRecognizer) {
        ImagePickerHandler(presentingViewController: self).selectPhotos()
        
    }
    
}
// MARK: - Collection View DataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifire,for: indexPath) as? ImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: photos[indexPath.row],
                       at: indexPath) { [weak self] indexPath in
            guard let strongSelf = self, let index = indexPath?.row else { return }
            strongSelf.photos.remove(at: index)
        }
        return cell
    }
}
// MARK: - Collection View Flow Layout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace - 40
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView( _ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
// MARK: - Text View Delegate
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = messageTextViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
}
// MARK: - SupportMessageViewControllerProtocol
extension ViewController: SupportMessageViewControllerProtocol {
    func assignSelected(_ category: Category) { // first time and when choose category
        categoryLabel.text = category.category
        subCategoryLabel.text = category.subCategory?.first?.name
    }
    
    func showProvided(_ categories: [Category]) {
        showActionSheet(with: categories.map { $0.category }, using: didSelectCategory)
    }
    
    func showProvided(_ subCategories: [SubCategory]) {
        showActionSheet(with: subCategories.map { $0.name }, using: didSelectSubCategory)
        
    }
    
    private func showActionSheet(with options: [String?], using action: ((UIAlertAction) -> Void)?) {
        let optionMenu = UIAlertController(title: nil,
                                           message: "Choose Option",
                                           preferredStyle: .actionSheet)
        
        options.forEach { option in
            optionMenu.addAction(UIAlertAction(title: option,
                                               style: .default,
                                               handler: action))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func didSelectCategory(with action: UIAlertAction) {
        presenter?.didSelectCategory(with: action.title)
    }
    
    private func didSelectSubCategory(with action: UIAlertAction) {
        subCategoryLabel.text = action.title
        presenter?.didSelectSubCategory(with: action.title)
    }
}
// MARK: - Image Picker Delegate
extension ViewController: ImagePickerDelegate {
    func didFinishPicking(_ photos: [UIImage]) {
        self.photos.append(contentsOf: photos)
    }
}

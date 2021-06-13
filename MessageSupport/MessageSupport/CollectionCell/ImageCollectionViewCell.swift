//
//  ImageCollectionViewCell.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private var indexPath: IndexPath?
    private var deleteHandler: ((IndexPath?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        deleteHandler?(indexPath)
    }
    
    func configure(with photo: UIImage, at indexPath: IndexPath, deleteHandler: ((IndexPath?) -> Void)?) {
        imageView.image = photo
        self.indexPath = indexPath
        self.deleteHandler = deleteHandler
    }
}
extension UICollectionViewCell {
    static var identifire: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: self.identifire, bundle: nil) }
}

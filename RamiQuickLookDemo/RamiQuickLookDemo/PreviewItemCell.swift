//
//  PreviewItemCell.swift
//  RamiQuickLookDemo
//
//  Created by RamiReddy on 11/12/22.
//

import UIKit

class PreviewItemCell: UICollectionViewCell {
    
    static let cellIdentifier = "PreviewItemCell"
    static let xibFile = UINib(nibName: cellIdentifier, bundle: nil)
    
    @IBOutlet weak var previewItemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpPreviewItem(file:File) {
        file.generateThumbNail { [weak self] image in
            DispatchQueue.main.async {
                self?.previewItemImageView.image = image

            }
        }
    }

}

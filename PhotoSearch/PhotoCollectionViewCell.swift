//
//  PhotoCollectionViewCell.swift
//  PhotoSearch
//
//  Created by Soto Nicole on 30.11.23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "photo"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
        isSelected = false
        isHighlighted = false
        
        imageView.image = nil
    }
    
    func loadPhotos(urlString: String){
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil else{ return }
            let image = UIImage(data: data)
            self.imageView.image = image
        }.resume()
    }
    
}

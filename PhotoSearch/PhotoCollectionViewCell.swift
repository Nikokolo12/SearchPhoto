//
//  PhotoCollectionViewCell.swift
//  PhotoSearch
//
//  Created by Soto Nicole on 30.11.23.
//

import UIKit

var imageCache = NSCache<NSURL, UIImage>()

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "photo"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
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
        guard let url = NSURL(string: urlString) else{ return }
        
        if let image = imageCache.object(forKey: url) {
            self.imageView.image = image
        }
        
        URLSession.shared.dataTask(with: url as URL){ [weak self] data, _, error in
                    guard let self = self,
                          let data = data,
                          error == nil else{ return }
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        imageCache.setObject(image!, forKey: url)
                        self.imageView.image = image
                    }
                }.resume()
            }
        }

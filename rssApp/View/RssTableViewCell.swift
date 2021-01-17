//
//  RssTableViewCell.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import UIKit
import SnapKit
import SDWebImage

class RssTableViewCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(title: String, imgUrls: [String], filter: FilterState) {
        
        self.addSubview(cellImageView)
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(4)
        }
        
        cellImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        titleLabel.text = title
        guard imgUrls.count > 0 , let url =  URL(string: imgUrls[0])  else { return }

        cellImageView.sd_setImage(with: url, placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { [weak self] image, error, cacheType, imageURL in
             
            guard let self = self, let img = image else { return }
            switch filter {
            
            case .blur:
                let blur = self.blurImage(image: img)
                self.cellImageView.image = blur
                
            case .noColor:
                let noColor = self.convertToGrayScale(image: img)
                self.cellImageView.image = noColor
                
            default:
                self.cellImageView.image = img
            }
        })
    }

    func convertToGrayScale(image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
    
    func blurImage(image:UIImage) -> UIImage? {
            let context = CIContext(options: nil)
            let inputImage = CIImage(image: image)
            let originalOrientation = image.imageOrientation
            let originalScale = image.scale

            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(10.0, forKey: kCIInputRadiusKey)
            let outputImage = filter?.outputImage

            var cgImage:CGImage?

            if let asd = outputImage
            {
                cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
            }

            if let cgImageA = cgImage
            {
                return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
            }
            return nil
        }
}

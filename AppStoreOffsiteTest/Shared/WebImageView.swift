//
//  WebImageView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {

    private(set) open var imageURL: URL?
    
    open func setImage(with imageURL: URL?, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        image = placeholder
        backgroundColor = UIColor.lightGray
        
        guard let imageURL = imageURL else {
            return
        }
        
        
        
        self.imageURL = imageURL
        
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: imageURL)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = image
                    completion?(image)
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }
}

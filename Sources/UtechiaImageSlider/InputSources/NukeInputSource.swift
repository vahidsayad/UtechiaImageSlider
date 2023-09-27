//
//  NukeInputSource.swift
//  ImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import UIKit
import Nuke

class NukeInputSource: NSObject, InputSource {
    var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        if let url = url {
            ImagePipeline.shared.loadImage(with: url) { result in
                switch result {
                case .success(let success):
                    callback(success.image)
                case .failure:
                    callback(nil)
                }
            }
        } else {
            callback(nil)
        }
    }
}

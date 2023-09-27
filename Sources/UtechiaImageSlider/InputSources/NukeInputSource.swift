//
//  NukeInputSource.swift
//  ImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import UIKit
import Nuke

public class NukeInputSource: NSObject, InputSource {
    private let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
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

//
//  UtechiaImageSliderView.swift
//  UtechiaImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import SwiftUI

public struct UtechiaImageSliderView: UIViewRepresentable {
    public let slideShow = ImageSlideshow()
    
    public let inputSources: [InputSource]
    @Binding public var currentPageNumber: Int
    public let isZoomEnabled: Bool = true
    public let maximumZoomScale: CGFloat = 3.5
    public let isCircular: Bool = false
    public var singleTapped: (() -> Void)?
    
    public func makeUIView(context: Context) -> ImageSlideshow {
        slideShow.setImageInputs(inputSources)
        slideShow.zoomEnabled = isZoomEnabled
        slideShow.maximumScale = maximumZoomScale
        slideShow.pageIndicator = nil
        slideShow.circular = isCircular
        slideShow.delegate = context.coordinator
        slideShow.activityIndicator = DefaultActivityIndicator(style: .medium, color: .white)
        slideShow.backgroundColor = UIColor.clear
        return slideShow
    }
    
    public class Coordinator: ImageSlideshowDelegate {
        var slideShow: ImageSlideshow
        var currentPageIsSet = false
        var singleTapped: (() -> Void)?
        
        init(slideShow: ImageSlideshow, singleTapped: (() -> Void)?) {
            self.slideShow = slideShow
            self.singleTapped = singleTapped
        }
        
        func singleTapped(_ imageSlideshow: ImageSlideshow) {
            singleTapped?()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(slideShow: slideShow, singleTapped: singleTapped)
    }
    
    public func updateUIView(_ uiView: ImageSlideshow, context: Context) {
        if !context.coordinator.currentPageIsSet {
            slideShow.setCurrentPage(currentPageNumber, animated: true)
            context.coordinator.currentPageIsSet = true
        }
        uiView.currentPageChanged = { number in
            currentPageNumber = number
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
    }
}

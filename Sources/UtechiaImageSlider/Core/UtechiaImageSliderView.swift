//
//  UtechiaImageSlider.swift
//  UtechiaImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import SwiftUI

public struct UtechiaImageSlider: UIViewRepresentable {
    public let slideShow = ImageSlideshow()
    
    public let inputSources: [InputSource]
    @Binding public var currentPageNumber: Int
    public let isZoomEnabled: Bool
    public let maximumZoomScale: CGFloat
    public let isCircular: Bool
    public let contentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit
    public var singleTapped: (() -> Void)?
    
    public init(inputSources: [InputSource],
                currentPageNumber: Binding<Int>,
                isZoomEnabled: Bool = true,
                maximumZoomScale: CGFloat = 3.5,
                isCircular: Bool = false,
                singleTapped: (() -> Void)?) {
        self.inputSources = inputSources
        self._currentPageNumber = currentPageNumber
        self.isZoomEnabled = isZoomEnabled
        self.maximumZoomScale = maximumZoomScale
        self.isCircular = isCircular
        self.singleTapped = singleTapped
    }
    
    public func makeUIView(context: Context) -> ImageSlideshow {
        slideShow.setImageInputs(inputSources)
        slideShow.zoomEnabled = isZoomEnabled
        slideShow.maximumScale = maximumZoomScale
        slideShow.pageIndicator = nil
        slideShow.circular = isCircular
        slideShow.contentScaleMode = contentMode
        slideShow.delegate = context.coordinator
        slideShow.activityIndicator = DefaultActivityIndicator(style: .medium, color: .white)
        slideShow.backgroundColor = UIColor.clear
        return slideShow
    }
    
    public class Coordinator: ImageSlideshowDelegate {
        public var slideShow: ImageSlideshow
        public var currentPageIsSet = false
        public var singleTapped: (() -> Void)?
        
        public init(slideShow: ImageSlideshow, singleTapped: (() -> Void)?) {
            self.slideShow = slideShow
            self.singleTapped = singleTapped
        }
        
        public func singleTapped(_ imageSlideshow: ImageSlideshow) {
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

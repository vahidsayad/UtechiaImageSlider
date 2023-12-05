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
    public let contentMode: UIViewContentMode
    public let showPageIndicator: Bool
    public let currentPageIndicatorTintColor: UIColor
    public let pageIndicatorTintColor: UIColor
    public let pageIndicatorPosition: PageIndicatorPosition
    public var singleTapped: (() -> Void)?
    
    public init(inputSources: [InputSource],
                currentPageNumber: Binding<Int>,
                isZoomEnabled: Bool = true,
                maximumZoomScale: CGFloat = 3.5,
                isCircular: Bool = false,
                contentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit,
                showPageIndicator: Bool = false,
                currentPageIndicatorTintColor: UIColor = .lightGray,
                pageIndicatorTintColor: UIColor = .black,
                pageIndicatorPosition: PageIndicatorPosition = .init(),
                singleTapped: (() -> Void)?) {
        self.inputSources = inputSources
        self._currentPageNumber = currentPageNumber
        self.isZoomEnabled = isZoomEnabled
        self.maximumZoomScale = maximumZoomScale
        self.isCircular = isCircular
        self.contentMode = contentMode
        self.showPageIndicator = showPageIndicator
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.pageIndicatorPosition = pageIndicatorPosition
        self.singleTapped = singleTapped
    }
    
    public func makeUIView(context: Context) -> ImageSlideshow {
        slideShow.setImageInputs(inputSources)
        slideShow.zoomEnabled = isZoomEnabled
        slideShow.maximumScale = maximumZoomScale
        if showPageIndicator {
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = currentPageIndicatorTintColor
            pageIndicator.pageIndicatorTintColor = pageIndicatorTintColor
            slideShow.pageIndicator = pageIndicator
            slideShow.pageIndicatorPosition = pageIndicatorPosition
        } else {
            slideShow.pageIndicator = nil
        }
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

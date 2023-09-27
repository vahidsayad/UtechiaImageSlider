//
//  UtechiaImageSlider.swift
//  UtechiaImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import SwiftUI

public struct UtechiaImageSlider: UIViewRepresentable {
    private let slideShow = ImageSlideshow()
    
    private let inputSources: [InputSource]
    @Binding private var currentPageNumber: Int
    private let isZoomEnabled: Bool
    private let maximumZoomScale: CGFloat
    private let isCircular: Bool
    private var singleTapped: (() -> Void)?
    
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
    
    func makeUIView(context: Context) -> ImageSlideshow {
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
    
    class Coordinator: ImageSlideshowDelegate {
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(slideShow: slideShow, singleTapped: singleTapped)
    }
    
    func updateUIView(_ uiView: ImageSlideshow, context: Context) {
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

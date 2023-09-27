//
//  UtechiaImageSlider.swift
//  UtechiaImageSlider
//
//  Created by Vahid Sayad on 9/25/23.
//

import SwiftUI

public struct UtechiaImageSlider: UIViewRepresentable {
    private let slideShow = ImageSlideshow()
    
    let inputSources: [InputSource]
    @Binding var currentPageNumber: Int
    var isZoomEnabled = true
    var maximumZoomScale = 3.5
    var isCircular = false
    var singleTapped: (() -> Void)?
    
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

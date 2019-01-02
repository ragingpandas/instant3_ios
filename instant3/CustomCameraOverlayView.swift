//
//  CustomOverlayView.swift
//  PicturePyramid
//
//  Created by Adela Gao on 8/10/16.
//  Copyright © 2016 Adela Gao. All rights reserved.
//

import UIKit

protocol CustomOverlayDelegate{
    func didCancel(_ overlayView:CustomCameraOverlayView)
    func didShoot(_ overlayView:CustomCameraOverlayView)
}

class CustomCameraOverlayView: UIView {
    
    var delegate:CustomOverlayDelegate!

    weak var picker: UIImagePickerController? {
        didSet {
            if let picker = picker {
                picker.sourceType = .camera
                picker.showsCameraControls = false
                adjustPreviewHeight()
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    picker.cameraDevice = .front
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate.didCancel(self)
    }
    
    @IBAction func shootButtonTapped(_ sender: UIButton) {
        delegate.didShoot(self)
    }
    
    @IBAction func flashButtonTapped(_ sender: UIButton) {
        if let flashState = picker?.cameraFlashMode {
            switch flashState {
            case .on:
                picker?.cameraFlashMode = .off
            case .off:
                picker?.cameraFlashMode = .auto
            case .auto:
                picker?.cameraFlashMode = .on
            }
        }
    }
    
    func adjustPreviewHeight() {
        let bounds = UIScreen.main.bounds
        let height = CGFloat(bounds.size.height)
        let topBarHeight = height - ParseHelper.topHeight - CGFloat(50.0) // Change it based on your view
        if let picker = picker {
            picker.cameraViewTransform = picker.cameraViewTransform.translatedBy(x: 0.0, y: topBarHeight)
        }
    }
    
}


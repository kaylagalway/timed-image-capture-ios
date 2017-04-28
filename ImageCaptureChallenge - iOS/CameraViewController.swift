//
//  CameraViewController.swift
//  ImageCaptureChallenge - iOS
//
//  Created by Kayla Galway on 4/28/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
  
  @IBOutlet weak var cameraPreviewView: UIView!
  @IBOutlet weak var photoCountLabel: UILabel!
  
  let captureSession = AVCaptureSession()
  var captureDevice: AVCaptureDevice?
  var output = AVCapturePhotoOutput()
  var videoPreviewLayer = AVCaptureVideoPreviewLayer()
  var photoCount = 0
  var imagesArray = [UIImage]()
  
  override func viewDidLoad() {
    setUpCaptureDevice()
  }
  
  private func setUpCaptureDevice() {
    captureSession.sessionPreset = AVCaptureSessionPresetHigh
    if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
      captureDevice = device
      beginSession()
    }
  }
  
  private func beginSession() {
    let err: Error? = nil
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      captureSession.addInput(input)
    } catch _ {
      print("error: \(String(describing: err?.localizedDescription))")
    }
    guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
      return
    }
    videoPreviewLayer = previewLayer
    let frame = cameraPreviewView.layer.frame
    videoPreviewLayer.frame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height)
    cameraPreviewView.layer.addSublayer(videoPreviewLayer)
    captureSession.startRunning()
    captureOutput()
  }
  
  private func captureOutput() {
    guard captureSession.canAddOutput(output) else {
      return
    }
    captureSession.addOutput(output)
    takeTenPhotos()
  }
  
  private func takeTenPhotos() {
    let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(takePhoto(timer:)), userInfo: nil, repeats: true)
  }
  
  @objc private func takePhoto(timer: Timer) {
    guard photoCount < 10 else {
      timer.invalidate()
      print(imagesArray)
      dismiss(animated: true, completion: nil)
      return
    }
    let settings = AVCapturePhotoSettings()
    let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
    let previewFormat = [
      kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
      kCVPixelBufferWidthKey as String: 160,
      kCVPixelBufferHeightKey as String: 160
    ]
    settings.previewPhotoFormat = previewFormat
    output.capturePhoto(with: settings, delegate: self)
    photoCount += 1
    photoCountLabel.text = String(photoCount)
  }
  
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
    }
    if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
      if let imagething = UIImage(data: dataImage) {
        imagesArray.append(imagething)
      }
    }
  }

}

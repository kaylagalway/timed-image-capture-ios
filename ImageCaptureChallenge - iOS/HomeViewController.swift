//
//  HomeViewController.swift
//  ImageCaptureChallenge - iOS
//
//  Created by Kayla Galway on 4/28/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    
  }
  
  @IBAction func takePhotosButtonTapped(_ sender: Any) {
    let cameraViewController = storyboard?.instantiateViewController(withIdentifier: "cameraVC") as! CameraViewController
    present(cameraViewController, animated: true, completion: nil)
  }
}

//
//  ViewController.swift
//  SiteCapture
//
//  Created by Glenn Posadas on 4/8/24.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: -
  // MARK: Properties
  
  var cameraTypeView: FNCameraTypeView!
  
  // MARK: -
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    cameraTypeView = .init(delegate: self)
    cameraTypeView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(cameraTypeView)
    
    NSLayoutConstraint.activate([
      cameraTypeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      cameraTypeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
    ])
  }
}

extension ViewController: FNCameraTypeViewDelegate {
  func cameraTypeView(_ cameraTypeView: FNCameraTypeView, didSelectCameraType type: CameraType) {
    debugPrint("👌 didSelectCameraType: \(type)")
  }
}

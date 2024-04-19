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
  var v = UIView()
  
  // MARK: -
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    v.backgroundColor = .red
    v.isUserInteractionEnabled = true
    view.addSubview(v)
    
    v.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      v.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      v.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      v.heightAnchor.constraint(equalToConstant: 500),
      v.widthAnchor.constraint(equalToConstant: view.bounds.width),
    ])
    
    cameraTypeView = .init(delegate: self)
    cameraTypeView.translatesAutoresizingMaskIntoConstraints = false
    v.addSubview(cameraTypeView)
    
    cameraTypeView.isUserInteractionEnabled = true
    
    NSLayoutConstraint.activate([
      cameraTypeView.centerXAnchor.constraint(equalTo: v.centerXAnchor),
      cameraTypeView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -16)
    ])
  }
}

extension ViewController: FNCameraTypeViewDelegate {
  func cameraTypeView(_ cameraTypeView: FNCameraTypeView, didSelectCameraType type: CameraType) {
    debugPrint("👌 didSelectCameraType: \(type)")
  }
}

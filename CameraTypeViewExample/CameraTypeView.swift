//
//  CameraTypeView.swift
//  SiteCapture
//
//  Created by Glenn Posadas on 4/8/24.
//

import UIKit

// MARK: -
// MARK: OptionCell

class OptionCell: UICollectionViewCell {
  
  // MARK: Properties
  
  let optionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: Functions
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(optionLabel)
    NSLayoutConstraint.activate([
      optionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      optionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  // MARK: - Cell Highlighting
  
  func setHighlighted(_ highlighted: Bool) {
    optionLabel.textColor = highlighted ? .yellow : .white
  }
}

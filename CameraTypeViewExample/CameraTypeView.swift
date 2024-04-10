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
    let color: UIColor = highlighted ? .yellow : .white
    debugPrint("setHighlighted --> \(String(describing: optionLabel.text)) -> highlighted ? \(highlighted)")
    optionLabel.textColor = color
  }
}

// MARK: -
// MARK: CameraTypeView

class CameraTypeView: UIView {
  
  // MARK: Properties
  
  let options: [String] = ["", "PHOTO", "VIDEO", ""]
  var selectedIndex = 1
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 10
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .black
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "OptionCell")
    collectionView.backgroundColor = .lightGray
    return collectionView
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
    backgroundColor = .black
    
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
      collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
      collectionView.widthAnchor.constraint(equalToConstant: 250),
      collectionView.heightAnchor.constraint(equalToConstant: 50),
      
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

// MARK: UICollectionViewDataSource

extension CameraTypeView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
    
    cell.optionLabel.text = options[indexPath.item]
    
    if options[indexPath.item] == "PHOTO" {
      
      cell.setHighlighted(selectedIndex == 1)
      
    } else if options[indexPath.item] == "VIDEO" {
      
      cell.setHighlighted(selectedIndex == 2)
      
    }
    
    return cell
  }
}

// MARK: Set and Reset

extension CameraTypeView {
  // SET ----
  func setCenteredCell(_ scrollView: UIScrollView) {
    guard let superview = self.superview else { return }
    let y = frame.origin.y + 25
    let centerPoint = CGPoint(x: superview.bounds.midX, y: y)
    let collectionViewCenterPoint = superview.convert(centerPoint, to: collectionView)
    
    if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
      if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
        collectionViewCell.setHighlighted(true)
      }
    }
  }
  
  // RESET---
  func resetPreviouslyCentedCell(_ scrollView: UIScrollView) {
    guard let superview = self.superview else { return }
    let y = frame.origin.y + 25
    let centerPoint = CGPoint(x: superview.bounds.midX, y: y)
    let collectionViewCenterPoint = superview.convert(centerPoint, to: collectionView)
    
    if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
      if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
        collectionViewCell.setHighlighted(false)
      }
    }
  }
}

// MARK: UICollectionViewDelegate

extension CameraTypeView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let previousIndex = selectedIndex
    selectedIndex = indexPath.item
    
    collectionView.isPagingEnabled = false
    
    let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
    collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
      collectionViewCell.setHighlighted(true)
    }
    
    if let previousSelectedCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? OptionCell {
      previousSelectedCell.setHighlighted(false)
    }
    
    collectionView.isPagingEnabled = true
  }
    
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
      collectionViewCell.setHighlighted(false)
    }
  }
  
  // MARK: ScrollView Delegate

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    debugPrint("scrollViewWillBeginDragging")
    resetPreviouslyCentedCell(scrollView)
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    debugPrint("scrollViewWillBeginDecelerating")
    resetPreviouslyCentedCell(scrollView)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    debugPrint("scrollViewDidEndDecelerating")
    setCenteredCell(scrollView)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      debugPrint("scrollViewDidEndDragging")
      setCenteredCell(scrollView)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CameraTypeView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let o = options[indexPath.item]
    return .init(width: o == "VIDEO" || o == "PHOTO" ? 80 : 75, height: 44)
  }
}

//
//  FNCameraTypeView.swift
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
  
  var cameraType: CameraType?
  
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
// MARK: FNCameraTypeView

@objc
enum CameraType: Int {
  case photo = 1
  case video = 2
}

@objc
protocol FNCameraTypeViewDelegate: AnyObject {
  func cameraTypeView(_ cameraTypeView: FNCameraTypeView,
                      didSelectCameraType type: CameraType)
}

@IBDesignable
class FNCameraTypeView: UIView {
  
  // MARK: Properties
  
  let options: [String] = ["", "PHOTO", "VIDEO", ""]
  
  private(set) var selectedIndex = 1 {
    didSet {
      let newSelectedType: CameraType = selectedIndex == 1 ? .photo : .video
      debugPrint("CameraTypeView --> From  \(selectedType) -- to -- \(newSelectedType)")
      if selectedType != newSelectedType {
        selectedType = newSelectedType
      }
    }
  }
  
  @objc
  private(set) var selectedType: CameraType = .photo {
    didSet {
      delegate?.cameraTypeView(self, didSelectCameraType: selectedType)
    }
  }
  
  var newCenteredIndexWasFromDragging: Bool = false
  var previouslyCenteredIndex: Int?
  
  @objc
  weak var delegate: FNCameraTypeViewDelegate?
  
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
    collectionView.decelerationRate = .fast
    collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "OptionCell")
    return collectionView
  }()
  
  // MARK: Functions
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  convenience init(delegate: FNCameraTypeViewDelegate?) {
    self.init(frame: .zero)
    self.delegate = delegate
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = .clear
    
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

extension FNCameraTypeView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
    
    cell.optionLabel.text = options[indexPath.item]
    
    if options[indexPath.item] == "PHOTO" {
      
      cell.setHighlighted(selectedIndex == 1)
      cell.cameraType = .photo
      
    } else if options[indexPath.item] == "VIDEO" {
      
      cell.setHighlighted(selectedIndex == 2)
      cell.cameraType = .video
      
    }
    
    return cell
  }
}

// MARK: Set and Reset

extension FNCameraTypeView {
  // SET ----
  func setCenteredCell(_ scrollView: UIScrollView, shouldStoreIndex: Bool) {
    guard let superview = self.superview else { return }
    let y = frame.origin.y + 25
    let centerPoint = CGPoint(x: superview.bounds.midX, y: y)
    let collectionViewCenterPoint = superview.convert(centerPoint, to: collectionView)
    
    if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
      // Here, we can set the selectedIndex.
      if shouldStoreIndex {
        selectedIndex = indexPath.item
      }
      if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
        collectionViewCell.setHighlighted(true)
      }
    }
  }
  
  // RESET---
  func resetPreviouslyCentedCell(_ scrollView: UIScrollView, shouldStoreIndex: Bool) {
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
  
  func resetPreviouslyCentedCell(at indexPath: IndexPath) {
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
      collectionViewCell.setHighlighted(false)
    }
  }
}

// MARK: UICollectionViewDelegate

extension FNCameraTypeView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    debugPrint("didSelectItemAt - \(indexPath.item)")
    
    let previousIndex = selectedIndex
    let currentIndex = indexPath.item
    
    guard currentIndex == 1 || currentIndex == 2 else { return }
    
    newCenteredIndexWasFromDragging = false
    selectedIndex = indexPath.item
    
    collectionView.isPagingEnabled = false
    
    let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
    collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    
    if let previousSelectedCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? OptionCell {
      previousSelectedCell.setHighlighted(false)
    }
    
    if let currentSelectedCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
      currentSelectedCell.setHighlighted(true)
      currentSelectedCell.cameraType = .init(rawValue: selectedIndex)
    }
    
    collectionView.isPagingEnabled = true
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    debugPrint("didDeselectItemAt")
    
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
      collectionViewCell.setHighlighted(false)
    }
  }
  
  // MARK: ScrollView Delegate
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    debugPrint("scrollViewWillBeginDragging")
    newCenteredIndexWasFromDragging = true
    resetPreviouslyCentedCell(scrollView, shouldStoreIndex: false)
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    debugPrint("scrollViewWillBeginDecelerating")
    resetPreviouslyCentedCell(scrollView, shouldStoreIndex: false)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let previouslyCenteredIndex = previouslyCenteredIndex
    setCenteredCell(scrollView, shouldStoreIndex: newCenteredIndexWasFromDragging)
    
    if let previouslyCenteredIndex = previouslyCenteredIndex, previouslyCenteredIndex != selectedIndex {
      resetPreviouslyCentedCell(at: IndexPath(item: previouslyCenteredIndex, section: 0))
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      setCenteredCell(scrollView, shouldStoreIndex: false)
      previouslyCenteredIndex = selectedIndex
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FNCameraTypeView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let o = options[indexPath.item]
    return .init(width: o == "VIDEO" || o == "PHOTO" ? 80 : 75, height: 44)
  }
}

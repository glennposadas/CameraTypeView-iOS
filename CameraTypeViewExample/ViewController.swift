//
//  ViewController.swift
//  aaa
//
//  Created by Glenn Posadas on 4/8/24.
//


import UIKit

class OptionCell: UICollectionViewCell {
  // MARK: - Properties
  let optionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Setup
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



class ViewController: UIViewController {
  // MARK: - Properties
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
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      //      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      //      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.widthAnchor.constraint(equalToConstant: 250),
      collectionView.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    // Initially select the first option
  }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
    cell.optionLabel.text = options[indexPath.item]
    if options[indexPath.item] == "PHOTO" {
//      cell.contentView.backgroundColor = .red
      
      if selectedIndex == 1 {
        cell.optionLabel.textColor = .yellow
      } else {
        cell.optionLabel.textColor = .white
      }
      
    } else if options[indexPath.item] == "VIDEO" {
//      cell.contentView.backgroundColor = .green9
      if selectedIndex == 2 {
        cell.optionLabel.textColor = .yellow
      } else {
        cell.optionLabel.textColor = .white
      }
      
    } else {
      cell.contentView.backgroundColor = .systemPink
    }
    
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  private func scrollToSelectedItem() {
       let initialIndexPath = IndexPath(item: selectedIndex, section: 0)
    collectionView.scrollToItem(at: initialIndexPath, at: .left, animated: true)
   }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let previousIndex = selectedIndex
    selectedIndex = indexPath.item
    
    // Scroll to the selected item
    collectionView.isPagingEnabled = false

    let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
    collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    
    // Perform any additional actions on selection
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
        collectionViewCell.optionLabel.textColor = .yellow
    }
    
    // Reset color for previously selected item
    if let previousSelectedCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? OptionCell {
        previousSelectedCell.optionLabel.textColor = .white
    }
    
    collectionView.isPagingEnabled = true

  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
        collectionViewCell.optionLabel.textColor = .white
    }
  }

  // SET ----
  func setCenteredCell(_ scrollView: UIScrollView) {
      let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
      let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)

      if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
          if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
              collectionViewCell.optionLabel.textColor = .yellow
          }
      }
  }

  // RESET---
  func resetPreviouslyCentedCell(_ scrollView: UIScrollView) {
      let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
      let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)

      if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
          if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCell {
              collectionViewCell.optionLabel.textColor = .white
          }
      }
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      resetPreviouslyCentedCell(scrollView)
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
      resetPreviouslyCentedCell(scrollView)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      setCenteredCell(scrollView)
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !decelerate {
          setCenteredCell(scrollView)
      }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let o = options[indexPath.item]
    return .init(width: o == "VIDEO" || o == "PHOTO" ? 80 : 75, height: 44)
  }
}

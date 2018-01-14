//
//  PhotoSelectorViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 14/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class PhotoSelectorCollectionViewController: UICollectionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setupNavigationBar()
        registerCell()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    let headerId = "PhotoSelectorHeaderCellId"
    let cellId = "cellId"
    fileprivate func registerCell(){
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func setupNavigationBar(){
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelItem))
        let rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextItem))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func handleCancelItem(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextItem(){
        
    }
    
//Mark: CollectionViewDelegate, CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeaderCell
        return header
    }
    
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension PhotoSelectorCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //調整header大小
        let width = view.frame.width
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //調整每個section的inset
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //change列與列的間距
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //change行與行的間距
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 1
        let itemInRow: CGFloat = 4
        let paddingNumber: CGFloat = itemInRow - 1
        let width = (view.frame.width - padding * paddingNumber)/itemInRow
        let height = width
        return CGSize(width: width, height: height)
    }
}



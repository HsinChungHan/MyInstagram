//
//  PhotoSelectorViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 14/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Photos
class PhotoSelectorCollectionViewController: UICollectionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setupNavigationBar()
        registerCell()
        fetchPhotos()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    let headerId = "PhotoSelectorHeaderCellId"
    let cellId = "PhotoSelectorCellId"
    fileprivate func registerCell(){
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
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
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    fileprivate func fetchOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        //一開始最多抓取十張照片
        fetchOptions.fetchLimit = 1000
        //這邊可以設定圖片的先後順序，in the decending order
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    fileprivate func fetchPhotos(){
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects {[weak self] (asset, count, stop) in
                //asset: 抓取照片的地方; count: 抓了多少照片;
                //在這邊處理抓取到照片
                let imgManager = PHImageManager.default()
                //為了加快fetch photo的速度，我們可以抓小一點到照片
                //然後等到真正選到那張照片，在讓header的imgView去抓取assets中的原檔圖片去refresh
                let targetSize = CGSize(width: 200, height: 200)
                //讓圖片同步出現(也就是說等圖片都從asset抓取完後才會做別的事情)Ep13 07:30
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imgManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit , options: options, resultHandler: { (image, info) in
                    if let img = image{
                        self?.images.append(img)
                        self?.assets.append(asset)
                        if self?.selectedImage == nil{
                            //為headerView預設一張圖片
                            self?.selectedImage = img
                        }
                    }
                    
                    //Ep13 12:00
                    //因為count是從0開始，而allPhotos.count=10，所以當所有的照片從asset撈出來後，count = 9
                    //因此count == allPhotos.count - 1代表當所有照片都撈完後，執行collectionView?.reloadData()
                    if count == allPhotos.count - 1{
                        DispatchQueue.main.async {
                            self?.collectionView?.reloadData()
                        }
                    }
                })
            }
        }
        
    }
    
//Mark: CollectionViewDelegate, CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.image = images[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeaderCell
        
        if let selectedImage = selectedImage{
            if let index = self.images.index(of: selectedImage){
                let imgManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                let size = CGSize(width: 600, height: 600)
                let selectedAsset = assets[index]
                imgManager.requestImage(for: selectedAsset, targetSize: size, contentMode: .default, options: options) { (image, info) in
                    header.imageView.image = image
                }
            }
        }
        return header
    }
    
    var selectedImage: UIImage?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        collectionView.reloadData()
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



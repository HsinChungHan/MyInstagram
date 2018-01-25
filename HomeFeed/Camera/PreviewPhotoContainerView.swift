//
//  PreviewPhotoContainerView.swift
//  Instagram
//
//  Created by 辛忠翰 on 20/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    let previewImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let cancelButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func handleCancel(){
        self.removeFromSuperview()
    }
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func handleSave(){
        print("save photo into photos library...")
        guard let previewImage = previewImageView.image else {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let err = error{
                print("Failed to save photo into photos library: ", err.localizedDescription)
                return
            }
            if success{
                print("Successfulley save photo into photo library!!")
                DispatchQueue.main.async {
                    let saveLabel = UILabel()
                    saveLabel.text = "Saved Successfully"
                    saveLabel.textColor = UIColor.white
                    saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
                    saveLabel.textAlignment = .center
                    saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                    saveLabel.center = self.center
                    saveLabel.numberOfLines = 0
                    self.addSubview(saveLabel)
                    
                    saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                                saveLabel.alpha = 0
                        }, completion: { (_) in
                            saveLabel.removeFromSuperview()
                        })
                    })
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupButtons()
    }
    
    fileprivate func setupImageView(){
        addSubview(previewImageView)
        previewImageView.fullAnchor(super: self)
    }
    
    fileprivate func setupButtons(){
        addSubview(cancelButton)
        addSubview(saveButton)
        cancelButton.anchor(top: topAnchor, topPadding: 8, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 80, height: 80)
        saveButton.anchor(top: nil, topPadding: 0, bottom: bottomAnchor, bottomPadding: -8, left: cancelButton.leftAnchor, leftPadding: 0, right: nil, rightPadding: 0, width: 80, height: 80)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

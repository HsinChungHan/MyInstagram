//
//  Extension.swift
//  BelizeBuyAndSell
//
//  Created by 辛忠翰 on 07/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    //static fumc 為了讓其他檔案也可以呼叫這個func
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIButton {
    //讓button的backgroundColor根據狀態改變
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, topPadding: CGFloat , bottom: NSLayoutYAxisAnchor?, bottomPadding: CGFloat , left: NSLayoutXAxisAnchor?, leftPadding: CGFloat , right: NSLayoutXAxisAnchor?, rightPadding: CGFloat , width: CGFloat , height: CGFloat ){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomPadding).isActive = true
        }
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    func fullAnchor(super view: UIView) {
        anchor(top: view.topAnchor, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: 0, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: 0, height: 0)
    }
    
    
    func anchorWithSameSuperView(super view: UIView, topPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat, rightPadding: CGFloat) {
        anchor(top: view.topAnchor, topPadding: topPadding, bottom: view.bottomAnchor, bottomPadding: bottomPadding, left: view.leftAnchor, leftPadding: leftPadding, right: view.rightAnchor, rightPadding: rightPadding, width: 0, height: 0)
    }
}

extension Date{
    func timeAgoDisplay() -> String{
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let quotient: Int
        let unit: String
        if secondsAgo < minute{
            quotient = secondsAgo
            unit = "seconds"
        }else if secondsAgo < hour{
            quotient = secondsAgo / minute
            unit = "hours"
        }else if secondsAgo < day{
            quotient = secondsAgo / hour
            unit = "days"
        }else if secondsAgo < week{
            quotient = secondsAgo / day
            unit = "weeks"
        }else if secondsAgo < month{
            quotient = secondsAgo / week
            unit = "months"
        }else{
            quotient = 0
            unit = ""
        }
        
        return "\(quotient) \(unit) ago"
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}



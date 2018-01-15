//
//  CustomImageView.swift
//  Instagram
//
//  Created by 辛忠翰 on 15/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
class CustomImageView: UIImageView{
    var lastUrlUsedToLoadImage: String?
    func loadImage(urlString: String) {
        lastUrlUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                print("Failed to download the post image: ", err)
            }
            //Ep18 04:03有解釋，主要因為在下載照片會在background thread async執行，所以無法確保順序以及是否重複
            //有可能第一個的urlStr = "001"，接者去做downloadData的動作，接著第二個urlStr = "002"，插隊進來並做完downloadData的動作，後馬上出去。第一個urlStr又進來並取得第二個urlStr所下載的data。此時就會造成資料順序不對
            //主要原因是因為整個動作async的關係
            //可以防止下載重複的image
            if url.absoluteString != self.lastUrlUsedToLoadImage{
                return
            }
            guard let data = data else {
                print("No post image data!!")
                return
            }
            guard let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}

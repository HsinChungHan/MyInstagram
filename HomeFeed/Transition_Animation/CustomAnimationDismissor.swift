//
//  CustomAnimationPresentor.swift
//  Instagram
//
//  Created by 辛忠翰 on 21/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
class CustomAnimationDismissor: NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //整個轉場過程的時間
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //my custom transition animation code
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {return}
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        containerView.addSubview(toView)
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            //tell system u finished the transition, back ur app to working condition
            transitionContext.completeTransition(true)
        }
    }
    
    
}



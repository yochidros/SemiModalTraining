//
//  DismissAnimator.swift
//  SemiModalTraining
//
//  Created by Yoshiki Miyazawa on 2019/08/16.
//  Copyright © 2019 yochidros. All rights reserved.
//

import Foundation
import UIKit

final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        let option: UIView.AnimationOptions = transitionContext.isInteractive ? UIView.AnimationOptions.curveLinear : UIView.AnimationOptions.curveEaseIn
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

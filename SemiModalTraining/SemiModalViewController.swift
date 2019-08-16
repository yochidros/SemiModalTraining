//
//  SemiModalViewController.swift
//  SemiModalTraining
//
//  Created by Yoshiki Miyazawa on 2019/08/16.
//  Copyright © 2019 yochidros. All rights reserved.
//

import UIKit

class SemiModalViewController: UIViewController, OverCurrentTransitionable {
    var percentThreshold: CGFloat = 0.3
    var interactor: OverCurrentTransitioningInteractor = OverCurrentTransitioningInteractor()
    
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var contentsView: UIView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    static func make() -> SemiModalViewController {
        let story = UIStoryboard(name: "SemiModalViewController", bundle: nil)
        let vc = story.instantiateInitialViewController() as! SemiModalViewController
        return vc
    }
    
    private func setupViews() {
        contentsView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(contentsViewDidScroll(_:))))
        backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDidTapped)))
    }
    
    @objc private func contentsViewDidScroll(_ sender: UIPanGestureRecognizer) {
        interactor.updateStateShouldStartIfNeeded()
        handleTransitionGesture(sender)
    }
    @objc private func backgroundDidTapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension SemiModalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SemiModalViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch interactor.state {
        case .hasStarted, .shouldFinish:
            return interactor
        case .none, .shouldStart:
            return nil
        }
    }
}

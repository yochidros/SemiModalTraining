//
//  OverCurrentTransionable.swift
//  SemiModalTraining
//
//  Created by Yoshiki Miyazawa on 2019/08/16.
//  Copyright © 2019 yochidros. All rights reserved.
//

import Foundation
import UIKit

protocol OverCurrentTransitionable where Self: UIViewController {
    var percentThreshold: CGFloat { get }
    var interactor: OverCurrentTransitioningInteractor { get }
}

extension OverCurrentTransitionable {
    var shouldFinishVerocityY: CGFloat {
        return 1200
    }
}

extension OverCurrentTransitionable {
    func handleTransitionGesture(_ sender: UIPanGestureRecognizer) {
        switch interactor.state {
        case .shouldStart:
            interactor.state = .hasStarted
            dismiss(animated: true, completion: nil)
        case .hasStarted, .shouldFinish:
            break
        case .none:
            return
        }
        
        let translation = sender.translation(in: view)
        let verticalMovement = (CGFloat(translation.y) - interactor.startInteractionTranslationY) / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .changed:
            if progress > percentThreshold || sender.velocity(in: view).y > shouldFinishVerocityY {
                interactor.state = .shouldFinish
            } else {
                interactor.state = .hasStarted
            }
            interactor.update(progress)
        case .cancelled:
            interactor.cancel()
            interactor.reset()
        case .ended:
            switch interactor.state {
            case .shouldFinish:
                interactor.finish()
            case .hasStarted, .none, .shouldStart:
                interactor.cancel()
            }
            interactor.reset()
        default:
            break
        }
        print("Intercator State: \(interactor.state)")
    }
}


class OverCurrentTransitioningInteractor: UIPercentDrivenInteractiveTransition {
    enum State {
        case none
        case shouldStart
        case hasStarted
        case shouldFinish
    }
    
    var state: State = .none
    
    var startInteractionTranslationY: CGFloat = 0
    
    var startHandler: (() -> Void)?
    var resetHandler: (() -> Void)?
    
    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }
    
    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }
    
    func setStartInteractionTranslateY(_ translationY: CGFloat) {
        switch state {
        case .shouldStart:
            startInteractionTranslationY = translationY
        case .none, .hasStarted, .shouldFinish:
            break
        }
    }
    
    func updateStateShouldStartIfNeeded() {
        switch state {
        case .none:
            state = .shouldStart
            startHandler?()
        case .shouldStart, .hasStarted, .shouldFinish:
            break
        }
    }
    
    func reset() {
        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }
}

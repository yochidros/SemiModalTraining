//
//  ViewController.swift
//  SemiModalTraining
//
//  Created by Yoshiki Miyazawa on 2019/08/16.
//  Copyright © 2019 yochidros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func tappedButton() {
        let vc = SemiModalViewController.make()
        present(vc, animated: true, completion: nil)
    }

}


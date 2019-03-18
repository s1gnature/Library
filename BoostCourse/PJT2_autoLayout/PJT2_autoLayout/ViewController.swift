//
//  ViewController.swift
//  PJT2_autoLayout
//
//  Created by mong on 10/12/2018.
//  Copyright © 2018 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 오토 레이아웃을 걸기 전에는 유동적으로 뷰에 제약을 걸어둠. 그걸 코드상으로 해제를 시켜야
        // 코드에서 작업한 오토레이아웃과 충돌 X
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var constraintX: NSLayoutConstraint
        constraintX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        var constraintY: NSLayoutConstraint
        constraintY = button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        constraintX.isActive = true
        constraintY.isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        var labelConstraintX: NSLayoutConstraint
        labelConstraintX = label.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        
        var labelConstraintY: NSLayoutConstraint
        labelConstraintY = label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -50
        )
        
        labelConstraintX.isActive = true
        labelConstraintY.isActive = true
    }


}


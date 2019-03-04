//
//  ExampleViewController.swift
//  TidySplitsExample
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit
import TidySplits

class ExampleViewController: TidySplitsUIViewController {
  var button1: UIButton!
  var button2: UIButton!
  var button3: UIButton!
  var button4: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    button1 = UIButton(frame: CGRect.zero)
    button1.setTitle("Push primary", for: .normal)
    button1.addTarget(self, action: #selector(pushPrimary), for: .touchUpInside)
    self.view.addSubview(button1)
    
    button2 = UIButton(frame: CGRect.zero)
    button2.setTitle("Push detail", for: .normal)
    button2.addTarget(self, action: #selector(pushSecondary), for: .touchUpInside)
    self.view.addSubview(button2)
    
    button3 = UIButton(frame: CGRect.zero)
    button3.setTitle("Pop primary", for: .normal)
    button3.addTarget(self, action: #selector(popPrimary), for: .touchUpInside)
    self.view.addSubview(button3)
    
    button4 = UIButton(frame: CGRect.zero)
    button4.setTitle("Pop detail", for: .normal)
    button4.addTarget(self, action: #selector(popDetail), for: .touchUpInside)
    self.view.addSubview(button4)
    
    self.view.addSubview(button4)
  }
  
  override func viewWillLayoutSubviews() {
    self.button1.translatesAutoresizingMaskIntoConstraints = false
    self.button2.translatesAutoresizingMaskIntoConstraints = false
    self.button3.translatesAutoresizingMaskIntoConstraints = false
    self.button4.translatesAutoresizingMaskIntoConstraints = false
    
    button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button4.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
    button1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    button2.topAnchor.constraint(equalTo: self.button1.bottomAnchor, constant: 5).isActive = true
    button3.topAnchor.constraint(equalTo: self.button2.bottomAnchor, constant: 5).isActive = true
    button4.topAnchor.constraint(equalTo: self.button3.bottomAnchor, constant: 5).isActive = true
    
    super.viewWillLayoutSubviews()
  }
  
  @objc func pushPrimary() {
    let ctrl = ExampleViewController(.Primary)
    ctrl.view.backgroundColor = .blue
    self.tidySplitController?.push(ctrl)
  }
  
  @objc func pushSecondary() {
    let ctrl = ExampleViewController(.Detail)
    ctrl.view.backgroundColor = .purple
    self.tidySplitController?.push(ctrl)
  }
  
  @objc func popPrimary() {
    self.tidySplitController?.pop(from: .Primary)
  }
  
  @objc func popDetail() {
    self.tidySplitController?.pop(from: .Detail)
  }
}


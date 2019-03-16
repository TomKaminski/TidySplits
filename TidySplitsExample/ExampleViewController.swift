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
  var button5: UIButton!
  var button6: UIButton!
  var button7: UIButton!
  var button8: UIButton!

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
    
    button5 = UIButton(frame: CGRect.zero)
    button5.setTitle("Show detail (and refresh stack)", for: .normal)
    button5.addTarget(self, action: #selector(showSecondary), for: .touchUpInside)
    self.view.addSubview(button5)
    
    button6 = UIButton(frame: CGRect.zero)
    button6.setTitle("Push tabbar ctrl", for: .normal)
    button6.addTarget(self, action: #selector(pushTabBarCtrl), for: .touchUpInside)
    self.view.addSubview(button6)
    
    button7 = UIButton(frame: CGRect.zero)
    button7.setTitle("Go to checkpoint", for: .normal)
    button7.addTarget(self, action: #selector(goToCheckpoint), for: .touchUpInside)
    self.view.addSubview(button7)
    
    button8 = UIButton(frame: CGRect.zero)
    button8.setTitle("Set checkpoint here", for: .normal)
    button8.addTarget(self, action: #selector(setCheckpointHere), for: .touchUpInside)
    self.view.addSubview(button8)
  }
  
  override func viewWillLayoutSubviews() {
    self.button1.translatesAutoresizingMaskIntoConstraints = false
    self.button2.translatesAutoresizingMaskIntoConstraints = false
    self.button3.translatesAutoresizingMaskIntoConstraints = false
    self.button4.translatesAutoresizingMaskIntoConstraints = false
    self.button5.translatesAutoresizingMaskIntoConstraints = false
    self.button6.translatesAutoresizingMaskIntoConstraints = false
    self.button7.translatesAutoresizingMaskIntoConstraints = false
    self.button8.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button4.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button5.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button6.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button7.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button8.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

      button1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40),
      button2.topAnchor.constraint(equalTo: self.button1.bottomAnchor),
      button3.topAnchor.constraint(equalTo: self.button2.bottomAnchor),
      button4.topAnchor.constraint(equalTo: self.button3.bottomAnchor),
      button5.topAnchor.constraint(equalTo: self.button4.bottomAnchor),
      button6.topAnchor.constraint(equalTo: self.button5.bottomAnchor),
      button7.topAnchor.constraint(equalTo: self.button6.bottomAnchor),
      button8.topAnchor.constraint(equalTo: self.button7.bottomAnchor)
    ])

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
  
  @objc func pushTabBarCtrl() {
    let ctrl = ExampleTabController(.Detail)
    ctrl.view.backgroundColor = .gray
    self.tidySplitController?.push(ctrl)
  }
  
  @objc func showSecondary() {
    let ctrl = ExampleViewController(.Detail)
    ctrl.view.backgroundColor = .green
    self.tidySplitController?.showDetail(ctrl)
  }
  
  @objc func popPrimary() {
    self.tidySplitController?.pop(from: .Primary)
  }
  
  @objc func popDetail() {
    self.tidySplitController?.pop(from: .Detail)
  }
  
  @objc func goToCheckpoint() {
    self.tidySplitController?.goToCheckpoint(key: "hehexd")
  }
  
  @objc func setCheckpointHere() {
    self.view.backgroundColor = UIColor.cyan
    self.setupCheckpoint(with: "hehexd")
  }
}


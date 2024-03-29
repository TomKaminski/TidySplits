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
  var button0: UIButton!
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
    
    button0 = UIButton(frame: CGRect.zero)
    button0.setTitle("FULLSCREEN DETAIL", for: .normal)
    button0.addTarget(self, action: #selector(detailFullscreen), for: .touchUpInside)
    self.view.addSubview(button0)
    
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
    button5.addTarget(self, action: #selector(showSecondaryTabBar), for: .touchUpInside)
    self.view.addSubview(button5)
    
    
    button6 = UIButton(frame: CGRect.zero)
    button6.setTitle("Push tabbar ctrl", for: .normal)
    button6.addTarget(self, action: #selector(pushTabBarCtrl), for: .touchUpInside)
    self.view.addSubview(button6)
  }
  
  override func viewWillLayoutSubviews() {
    self.button0.translatesAutoresizingMaskIntoConstraints = false
    self.button1.translatesAutoresizingMaskIntoConstraints = false
    self.button2.translatesAutoresizingMaskIntoConstraints = false
    self.button3.translatesAutoresizingMaskIntoConstraints = false
    self.button4.translatesAutoresizingMaskIntoConstraints = false
    self.button5.translatesAutoresizingMaskIntoConstraints = false
    self.button6.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      button0.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button4.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button5.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button6.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),


      button0.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70),
      button1.topAnchor.constraint(equalTo: self.button0.bottomAnchor),
      button2.topAnchor.constraint(equalTo: self.button1.bottomAnchor),
      button3.topAnchor.constraint(equalTo: self.button2.bottomAnchor),
      button4.topAnchor.constraint(equalTo: self.button3.bottomAnchor),
      button5.topAnchor.constraint(equalTo: self.button4.bottomAnchor),
      button6.topAnchor.constraint(equalTo: self.button5.bottomAnchor),
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
  
  @objc func showSecondaryTabBar() {
    let ctrl = ExampleTabController(.Detail)
    ctrl.view.backgroundColor = .green
    self.tidySplitController?.showDetail(ctrl)
  }
  
  @objc func popPrimary() {
    self.tidySplitController?.pop(from: .Primary)
  }
  
  @objc func detailFullscreen() {
    self.tidySplitController?.toggleDetailFullscreen()
  }
  
  @objc func popDetail() {
    self.tidySplitController?.pop(from: .Detail)
  }
}


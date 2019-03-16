//
//  ExampleTabController.swift
//  TidySplitsExample
//
//  Created by Tomasz Kaminski on 3/12/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import Foundation
import TidySplits

class ExampleTabController: TidySplitsUITabBarViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let firstCtrl = ExampleViewController(.Detail)
    firstCtrl.view.backgroundColor = .red
    firstCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
    
    let secondCtrl = ExampleViewController(.Detail)
    secondCtrl.view.backgroundColor = .orange
    secondCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
    
    let thirdCtrl = ExampleViewController(.Detail)
    thirdCtrl.view.backgroundColor = .blue
    thirdCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
    
    self.viewControllers = [
      firstCtrl,
      secondCtrl,
      thirdCtrl
    ]
  }
}

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
    secondCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
    
    let thirdCtrl = ExampleViewController(.Detail)
    thirdCtrl.view.backgroundColor = .blue
    thirdCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
    
    let fourth = ExampleViewController(.Detail)
    firstCtrl.view.backgroundColor = .systemPink
    firstCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
    
    let fifth = ExampleViewController(.Detail)
    secondCtrl.view.backgroundColor = .blue
    secondCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 4)
    
    let sixth = ExampleViewController(.Detail)
    thirdCtrl.view.backgroundColor = .black
    thirdCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 5)
    
    let seventh = ExampleViewController(.Detail)
    firstCtrl.view.backgroundColor = .cyan
    firstCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 6)
    
    let eighth = ExampleViewController(.Detail)
    secondCtrl.view.backgroundColor = .white
    secondCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 7)
    
    let ninth = ExampleViewController(.Detail)
    thirdCtrl.view.backgroundColor = .gray
    thirdCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 8)
    
    self.viewControllers = [
      firstCtrl,
      secondCtrl,
      thirdCtrl,
      fourth,
      fifth,
      sixth,
      seventh,
      eighth,
      ninth
    ]
  }
}

//
//  MainSplitViewController.swift
//  TidySplitsExample
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import Foundation
import TidySplits

class ExampleSplitViewController: TidySplitsUISplitViewController, TidySplitsSplitViewDelegate {
  var shouldOmitDetailChildrenForCompactMode: Bool {
    return false
  }
  
  override func viewDidLoad() {
    self.delegate = self
    super.viewDidLoad()
  }
  
  func getDetailsPlaceholder() -> TidySplitsChildControllerProtocol {
    let ctrl = ExampleViewController(.Detail)
    ctrl.view.backgroundColor = .green
    return ctrl
  }
  
  func getInitialPrimaryControllers() -> [TidySplitsChildControllerProtocol] {
    let ctrl = ExampleViewController(.Primary)
    ctrl.view.backgroundColor = .blue
    return [ctrl]
  }
  
  func getInitialDetailControllers() -> [TidySplitsChildControllerProtocol] {
    let ctrl = ExampleTabController(.Detail)
    ctrl.view.backgroundColor = .red
    return [ctrl]
  }
}

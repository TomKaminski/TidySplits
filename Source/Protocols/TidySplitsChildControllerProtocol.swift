//
//  TidySplitsChildControllerProtocol.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

// NOTE: XCode 10.1 has a bug
// https://stackoverflow.com/questions/49662283/swift-inheriting-protocol-does-not-inherit-generic-where-constraint
// so we cannot constrain protocol to UIViewController...
public protocol TidySplitsChildControllerProtocol: class {
  var prefferedDisplayType: TidySplitsChildPreferedDisplayType { get set }
  
  var tidySplitController: TidySplitsUISplitViewController? { get }
  var tidyNavigationController: TidySplitsUINavigationController? { get }
  
  func postPopSelfNotification()
  func popSelf() -> UIViewController?
}

public extension TidySplitsChildControllerProtocol where Self: UIViewController  {
  var tidySplitController: TidySplitsUISplitViewController? {
    return self.navigationController?.parent as? TidySplitsUISplitViewController
  }
  
  var tidyNavigationController: TidySplitsUINavigationController? {
    return self.navigationController as? TidySplitsUINavigationController
  }
  
  @discardableResult func popSelf() -> UIViewController? {
    return self.tidySplitController?.pop(from: self.prefferedDisplayType)
  }
  
  func postPopSelfNotification() {
    if self.isMovingFromParent && tidySplitController?.remapingInProgress == false {
      if self.prefferedDisplayType == .Detail {
        NotificationCenter.default.post(name: .TidySplitsControllerDetailChildPopped, object: nil)
      } else {
        NotificationCenter.default.post(name: .TidySplitsControllerPrimaryChildPopped, object: nil)
      }
    }
  }
}

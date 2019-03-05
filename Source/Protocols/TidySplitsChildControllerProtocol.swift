//
//  TidySplitsChildControllerProtocol.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import Foundation
import UIKit

public protocol TidySplitsChildControllerProtocol where Self: UIViewController {
  var prefferedDisplayType: TidySplitsChildPreferedDisplayType! { get set }
  
  var tidySplitController: TidySplitsUISplitViewController? { get }
  var tidyNavigationController: TidySplitsUINavigationController? { get }
  
  func popSelf() -> UIViewController?
}

public extension TidySplitsChildControllerProtocol {
  var tidySplitController: TidySplitsUISplitViewController? {
    return self.navigationController?.parent as? TidySplitsUISplitViewController
  }
  
  var tidyNavigationController: TidySplitsUINavigationController? {
    return self.navigationController as? TidySplitsUINavigationController
  }
  
  @discardableResult func popSelf() -> UIViewController? {
    return self.tidySplitController?.pop(from: self.prefferedDisplayType)
  }
  
  internal func postPopSelfNotification() {
    if self.isMovingFromParent && tidySplitController?.remapingInProgress == false {
      if self.prefferedDisplayType == .Detail {
        NotificationCenter.default.post(name: .TidySplitsControllerDetailChildPopped, object: nil)
      } else {
        NotificationCenter.default.post(name: .TidySplitsControllerPrimaryChildPopped, object: nil)
      }
    }
  }
}

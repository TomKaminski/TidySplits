//
//  TidySplitsChildControllerProtocol.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

public protocol TidySplitsChildControllerProtocol: AnyObject {
  var allowAfterPopAction: Bool { get }
  
  var prefferedDisplayType: TidySplitsChildPreferedDisplayType { get set }
  
  var tidySplitController: TidySplitsUISplitViewController? { get }
  var tidyNavigationController: TidySplitsUINavigationController? { get }
  
  func popSelf() -> UIViewController?
  
  func postRotateNotification(isCollapsed: Bool, placedAtDetailStack: Bool)
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
  
  func handleOnPopOrDismiss() {
    if isMovingFromParent && allowAfterPopAction {
      self.tidySplitController?.navigator.afterPop(from: self.prefferedDisplayType)
    }
  }
}

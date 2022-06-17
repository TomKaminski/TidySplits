//
//  TidySplitsUIViewController.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

open class TidySplitsUIViewController: UIViewController, TidySplitsChildControllerProtocol {
  public var prefferedDisplayType: TidySplitsChildPreferedDisplayType
  
  public init(_ prefferedDisplayType: TidySplitsChildPreferedDisplayType, _ ignorePopNotifications: Bool = false) {
    self.prefferedDisplayType = prefferedDisplayType
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.prefferedDisplayType = .Detail
    super.init(coder: aDecoder)
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if isMovingFromParent || isBeingDismissed {
      self.tidySplitController?.navigator.afterPop(from: self.prefferedDisplayType)
    }
  }

  
  open func postRotateNotification(isCollapsed: Bool, placedAtDetailStack: Bool) {}
}

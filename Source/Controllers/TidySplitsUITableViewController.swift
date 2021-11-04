//
//  TidySplitsUITableViewController.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

open class TidySplitsUITableViewController: UITableViewController, TidySplitsCheckpointControllerProtocol {
  public var associatedCheckpointKey: String?
  public var prefferedDisplayType: TidySplitsChildPreferedDisplayType
  public var ignorePopNotifications: Bool

  public init(_ prefferedDisplayType: TidySplitsChildPreferedDisplayType, _ ignorePopNotifications: Bool = false) {
    self.prefferedDisplayType = prefferedDisplayType
    self.ignorePopNotifications = ignorePopNotifications

    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.prefferedDisplayType = .Detail
    self.ignorePopNotifications = false
    super.init(coder: aDecoder)
  }
  
  deinit {
    guard !ignorePopNotifications else {
      return
    }
    
    self.removeCheckpoint()
    self.postPopSelfNotification()
  }
  
  open func postRotateNotification(isCollapsed: Bool, placedAtDetailStack: Bool) {}
}

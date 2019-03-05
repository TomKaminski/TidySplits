//
//  TidySplitsUITabBarViewController.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

open class TidySplitsUITabBarViewController : UITabBarController, TidySplitsChildControllerProtocol {
  public var prefferedDisplayType: TidySplitsChildPreferedDisplayType!
  
  init(_ prefferedDisplayType: TidySplitsChildPreferedDisplayType) {
    super.init(nibName: nil, bundle: nil)
    self.prefferedDisplayType = prefferedDisplayType
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.postPopSelfNotification()
  }
}

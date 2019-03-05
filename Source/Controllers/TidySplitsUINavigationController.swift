//
//  TidySplitsUINavigationController.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/5/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

open class TidySplitsUINavigationController: UINavigationController {
  public var type: TidySplitsChildPreferedDisplayType
  
  open var tidySplitController: TidySplitsUISplitViewController? {
    return self.parent as? TidySplitsUISplitViewController
  }
  
  public init(_ type: TidySplitsChildPreferedDisplayType) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  public init(rootViewController: UIViewController,_ type: TidySplitsChildPreferedDisplayType) {
    self.type = type
    super.init(rootViewController: rootViewController)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func pushToMe(_ ctrl: TidySplitsChildControllerProtocol) {
    var remappedCtrl = ctrl
    remappedCtrl.prefferedDisplayType = self.type
    self.tidySplitController?.push(remappedCtrl)
  }
  
  open func popFromMe() {
    self.tidySplitController?.pop(from: self.type)
  }
}

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
  
  open func pushToMe(_ ctrl: TidySplitsChildControllerProtocol, animated: Bool = true) {
    var remappedCtrl = ctrl
    remappedCtrl.prefferedDisplayType = self.type
    self.tidySplitController?.push(remappedCtrl, animated: animated)
  }
  
  open func pushToMe(_ ctrl: UIViewController, _ animated: Bool = true) {
    guard var ctrl = ctrl as? TidySplitsChildControllerProtocol else {
      return
    }
    ctrl.prefferedDisplayType = self.type
    self.tidySplitController?.push(ctrl, animated: animated)
  }
  
  open func popFromMe(animated: Bool = true) {
    self.tidySplitController?.pop(from: self.type, animated: animated)
  }
  
  @discardableResult open func replaceLast(_ newCtrl: TidySplitsChildControllerProtocol, animated: Bool = true) -> TidySplitsChildControllerProtocol {
    let poppedCtrl = self.tidySplitController?.pop(from: self.type, animated: false)
    self.tidySplitController?.push(newCtrl, animated: animated)
    return poppedCtrl as! TidySplitsChildControllerProtocol
  }
}

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
  
  open func pushToMe(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    controller.prefferedDisplayType = self.type
    self.tidySplitController?.push(controller, animated)
    completion?(controller)
  }
  
  open func tryPushToMe(_ controller: UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool {
    guard let controller = controller as? TidySplitsChildControllerProtocol else {
      return false
    }
    
    controller.prefferedDisplayType = self.type
    self.tidySplitController?.push(controller, animated)
    completion?(controller)
    return true
  }
  
  open func popFromMe(animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil) {
    let poppedCtrl = self.tidySplitController?.pop(from: self.type, animated)
    completion?(poppedCtrl)
  }
  
  @discardableResult open func replaceLast(_ newCtrl: TidySplitsChildControllerProtocol, animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> TidySplitsChildControllerProtocol {
    let poppedCtrl = self.tidySplitController?.pop(from: self.type, false)
    self.tidySplitController?.push(newCtrl, animated)
    completion?(newCtrl)
    return poppedCtrl as! TidySplitsChildControllerProtocol
  }
}

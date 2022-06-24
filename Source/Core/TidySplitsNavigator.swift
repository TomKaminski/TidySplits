//
//  TidySplitsNavigator.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/2/19.
//

import Foundation
import UIKit

public class TidySplitsNavigator {
  weak var delegate: TidySplitsNavigatorDelegate?

  public var primaryChilds: [TidySplitsChildControllerProtocol]
  public var detailChilds: [TidySplitsChildControllerProtocol]
  public var currentHorizontalClass: UIUserInterfaceSizeClass

  var primaryNavigationController: TidySplitsUINavigationController!
  var detailNavigationController: TidySplitsUINavigationController?

  var remapingInProgress: Bool = false

  public init(primaryChilds: [TidySplitsChildControllerProtocol], detailChilds: [TidySplitsChildControllerProtocol], sizeClass: UIUserInterfaceSizeClass) {
    self.primaryChilds = primaryChilds
    self.detailChilds = detailChilds
    self.currentHorizontalClass = sizeClass
  }

  @discardableResult open func getRegularStacks() -> (UINavigationController, UINavigationController) {
    guard !primaryChilds.isEmpty else {
      fatalError("Primary childs must not be empty.")
    }

    performRemapping {
      if primaryNavigationController == nil {
        primaryNavigationController = TidySplitsUINavigationController(.Primary)
      }
      primaryNavigationController.viewControllers = primaryChilds as! [UIViewController]


      detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
      if detailChilds.isEmpty {
        let defaultDetail = delegate!.getDetailPlaceholderController()
        detailChilds.append(defaultDetail)
      }
      detailNavigationController!.viewControllers = detailChilds as! [UIViewController]
    }

    return (primaryNavigationController, detailNavigationController!)
  }

  @discardableResult open func getCompactStack(omitDetailChilds: Bool) -> UINavigationController {
    performRemapping {
      if primaryNavigationController == nil {
        primaryNavigationController = TidySplitsUINavigationController(.Primary)
      }

      var ctrls = primaryChilds
      if !omitDetailChilds {
        ctrls.append(contentsOf: detailChilds)
      }

      primaryNavigationController.viewControllers = ctrls as! [UIViewController]
      detailNavigationController = nil
    }
    return primaryNavigationController
  }

  // ------------------------
  // MARK: Navigation methods
  // ------------------------

  open func showDetail(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    assert(controller.prefferedDisplayType == .Detail, "So you want to show in detail context but with primary controller. Where is the logic here? Think about it bro.")
    let workingDetailChilds = [controller]
    if self.currentHorizontalClass == .regular {
      if let detailNav = self.detailNavigationController {
        detailNav.popToRootViewController(animated: false)
        detailNav.view.layoutIfNeeded()
        detailNav.setViewControllers(workingDetailChilds as! [UIViewController], animated: animated)
        detailNav.view.layoutIfNeeded()
      } else {
        detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
        detailNavigationController?.viewControllers = workingDetailChilds as! [UIViewController]
        detailNavigationController?.view.layoutIfNeeded()
      }
    } else {
      primaryNavigationController.popToRootViewController(animated: false)
      primaryNavigationController.view.layoutIfNeeded()
      primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
      primaryNavigationController?.view.layoutIfNeeded()
    }
    detailChilds = workingDetailChilds
    completion?(controller)
  }

  open func tryPush(_ controller: UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool {
    guard let controller = controller as? TidySplitsUIViewController else {
      return false
    }

    self.push(controller)
    completion?(controller)
    return true
  }

  open func push(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    assert(controller as? UIViewController != nil, "Subclass of UIViewController must be pushed to this function only.")

    if self.currentHorizontalClass == .regular {
      if controller.prefferedDisplayType == .Detail {
        detailChilds.append(controller)
        if let detailNav = self.detailNavigationController {
          detailNav.pushViewController(controller as! UIViewController, animated: animated)
        } else {
          detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
          detailNavigationController?.viewControllers = [controller] as! [UIViewController]
        }
      } else {
        primaryChilds.append(controller)
        primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
      }
    } else {
      if controller.prefferedDisplayType == .Detail {
        detailChilds.append(controller)
      } else {
        primaryChilds.append(controller)
      }

      primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
    }

    completion?(controller)
  }

  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType, _ animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil) -> UIViewController? {
    if self.currentHorizontalClass == .regular {
      if type == .Detail && detailChilds.count > 1 {
        let poppedCtrl = self.detailNavigationController?.popViewController(animated: animated)
        completion?(poppedCtrl)
      }

      if type == .Primary && primaryChilds.count > 1 {
        let poppedCtrl = self.primaryNavigationController.popViewController(animated: animated)
        completion?(poppedCtrl)
      }
    } else {
      if !detailChilds.isEmpty || primaryChilds.count > 1 {
        let poppedCtrl = self.primaryNavigationController.popViewController(animated: animated)
        completion?(poppedCtrl)
      }
    }

    return nil
  }
  
  public func afterPop(from type: TidySplitsChildPreferedDisplayType) {
    guard !remapingInProgress else {
      return
    }
    
    if(type == .Detail) {
      detailChilds.safeRemoveLast()
    } else if primaryChilds.count > 1 {
      primaryChilds.safeRemoveLast()
    }
  }

  // ---------------------
  // MARK: Private methods
  // ---------------------

  private func performRemapping(_ remapFunc: () -> Void) {
    self.remapingInProgress = true
    remapFunc()
    self.remapingInProgress = false
  }
}

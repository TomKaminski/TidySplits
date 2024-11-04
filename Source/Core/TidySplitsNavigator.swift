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

  public var primaryChildren: [TidySplitsChildControllerProtocol]
  public var detailChildren: [TidySplitsChildControllerProtocol]
  public var deviceHorizontalClass: UIUserInterfaceSizeClass

  var primaryNavigationController: TidySplitsUINavigationController!
  var detailNavigationController: TidySplitsUINavigationController?

  var remapingInProgress: Bool = false

  public var shouldRenderInRegularLayout: Bool {
    return deviceHorizontalClass == .regular && UIDevice.current.userInterfaceIdiom == .pad
  }

  public init(primaryChildren: [TidySplitsChildControllerProtocol], detailChildren: [TidySplitsChildControllerProtocol], sizeClass: UIUserInterfaceSizeClass) {
    self.primaryChildren = primaryChildren
    self.detailChildren = detailChildren
    self.deviceHorizontalClass = sizeClass
  }

  @discardableResult open func getRegularStacks() -> (UINavigationController, UINavigationController) {
    guard !primaryChildren.isEmpty else {
      fatalError("Primary children must not be empty.")
    }

    performRemapping {
      if primaryNavigationController == nil {
        primaryNavigationController = TidySplitsUINavigationController(.Primary)
      }
      primaryNavigationController.viewControllers = primaryChildren as! [UIViewController]

      detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
      if detailChildren.isEmpty {
        let defaultDetail = delegate!.getDetailPlaceholderController()
        detailChildren.append(defaultDetail)
      }
      detailNavigationController!.viewControllers = detailChildren as! [UIViewController]
    }

    return (primaryNavigationController, detailNavigationController!)
  }

  @discardableResult open func getCompactStack(omitDetailChildren: Bool) -> UINavigationController {
    performRemapping {
      if primaryNavigationController == nil {
        primaryNavigationController = TidySplitsUINavigationController(.Primary)
      }

      var ctrls = primaryChildren
      if !omitDetailChildren {
        ctrls.append(contentsOf: detailChildren)
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
    if shouldRenderInRegularLayout {
      if let detailNav = detailNavigationController {
        detailNav.popToRootViewController(animated: false)
        detailNav.view.layoutIfNeeded()
        
        setDetailChildren([controller])
        
        detailNav.setViewControllers(detailChildren as! [UIViewController], animated: animated)
        detailNav.view.layoutIfNeeded()
      } else {
        detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
        
        setDetailChildren([controller])
        
        detailNavigationController?.viewControllers = detailChildren as! [UIViewController]
        detailNavigationController?.view.layoutIfNeeded()
      }
    } else {
      primaryNavigationController.popToRootViewController(animated: false)
      primaryNavigationController.view.layoutIfNeeded()
      
      setDetailChildren([controller])
      
      primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
      primaryNavigationController?.view.layoutIfNeeded()
    }
    completion?(controller)
  }

  open func tryPush(_ controller: UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool {
    guard let controller = controller as? TidySplitsUIViewController else {
      return false
    }

    push(controller)
    completion?(controller)
    return true
  }

  open func push(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    assert(controller as? UIViewController != nil, "Subclass of UIViewController must be pushed to this function only.")

    if shouldRenderInRegularLayout {
      if controller.prefferedDisplayType == .Detail {
        detailChildren.append(controller)
        if let detailNav = detailNavigationController {
          detailNav.pushViewController(controller as! UIViewController, animated: animated)
        } else {
          detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
          detailNavigationController?.viewControllers = [controller] as! [UIViewController]
        }
      } else {
        primaryChildren.append(controller)
        primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
      }
    } else {
      if controller.prefferedDisplayType == .Detail {
        detailChildren.append(controller)
      } else {
        primaryChildren.append(controller)
      }

      primaryNavigationController.pushViewController(controller as! UIViewController, animated: animated)
    }

    completion?(controller)
  }

  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType, _ animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil) -> UIViewController? {
    if shouldRenderInRegularLayout {
      if type == .Detail, detailChildren.count > 1 {
        let poppedCtrl = detailNavigationController?.popViewController(animated: animated)
        completion?(poppedCtrl)
      }

      if type == .Primary, primaryChildren.count > 1 {
        let poppedCtrl = primaryNavigationController.popViewController(animated: animated)
        completion?(poppedCtrl)
      }
    } else {
      if !detailChildren.isEmpty || primaryChildren.count > 1 {
        let poppedCtrl = primaryNavigationController.popViewController(animated: animated)
        completion?(poppedCtrl)
      }
    }

    return nil
  }

  public func afterPop(from type: TidySplitsChildPreferedDisplayType) {
    guard !remapingInProgress else {
      return
    }

    if type == .Detail {
      detailChildren.safeRemoveLast()
    } else if primaryChildren.count > 1 {
      primaryChildren.safeRemoveLast()
    }
  }

  // ---------------------

  // MARK: Private methods

  // ---------------------
  
  private func setDetailChildren(_ children: [TidySplitsChildControllerProtocol]) {
    performRemapping {
      self.detailChildren = children
    }
  }

  private func performRemapping(_ remapFunc: () -> Void) {
    remapingInProgress = true
    remapFunc()
    remapingInProgress = false
  }
}

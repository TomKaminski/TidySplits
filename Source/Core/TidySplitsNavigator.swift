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
  
  var primaryChilds: [TidySplitsChildControllerProtocol]
  var detailChilds: [TidySplitsChildControllerProtocol]
  
  var primaryNavigationController: TidySplitsUINavigationController!
  var detailNavigationController: TidySplitsUINavigationController?
  var currentHorizontalClass: UIUserInterfaceSizeClass
  
  var remapingInProgress: Bool = false
  
  public init(primaryChilds: [TidySplitsChildControllerProtocol], detailChilds: [TidySplitsChildControllerProtocol], sizeClass: UIUserInterfaceSizeClass) {
    self.primaryChilds = primaryChilds
    self.detailChilds = detailChilds
    self.currentHorizontalClass = sizeClass
    
    NotificationCenter.default.addObserver(self, selector: #selector(popPrimaryChildFromStack), name: .TidySplitsControllerPrimaryChildPopped, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(popDetailChildFromStack), name: .TidySplitsControllerDetailChildPopped, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func popDetailChildFromStack() {
    detailChilds.safeRemoveLast()
  }
  
  @objc private func popPrimaryChildFromStack() {
    primaryChilds.safeRemoveLast()
  }
  
  private func performRemapping(_ remapFunc: () -> Void) {
    self.remapingInProgress = true
    remapFunc()
    self.remapingInProgress = false
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
      
      detailNavigationController = TidySplitsUINavigationController(.Detail)
      if detailChilds.isEmpty {
        //TODO
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
  
  open func push<TCtrl: TidySplitsChildControllerProtocol>(_ ctrl: TCtrl) {
    if self.currentHorizontalClass == .regular {
      if ctrl.prefferedDisplayType == .Detail {
        detailChilds.append(ctrl)
        if let detailNav = self.detailNavigationController {
          detailNav.pushViewController(ctrl, animated: true)
        } else {
          detailNavigationController = TidySplitsUINavigationController(rootViewController: ctrl, .Detail)
        }
      } else {
        primaryChilds.append(ctrl)
        primaryNavigationController.pushViewController(ctrl, animated: true)
      }
    } else {
      ctrl.prefferedDisplayType == .Detail
        ? detailChilds.append(ctrl)
        : primaryChilds.append(ctrl)
      primaryNavigationController.pushViewController(ctrl, animated: true)
    }
  }
  
  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType) -> UIViewController? {
    if self.currentHorizontalClass == .regular {
      if type == .Detail && detailChilds.count > 1 {
        return self.detailNavigationController?.popViewController(animated: true)
      }
      
      if type == .Primary && primaryChilds.count > 1 {
        return self.primaryNavigationController.popViewController(animated: true)
      }
    } else {
      if !detailChilds.isEmpty || primaryChilds.count > 1 {
        return self.primaryNavigationController.popViewController(animated: true)
      }
    }
    
    return nil
  }
}

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

    NotificationCenter.default.addObserver(forName: .TidySplitsControllerPrimaryChildPopped, object: nil, queue: nil) { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      if strongSelf.primaryChilds.count > 1 {
        strongSelf.primaryChilds.safeRemoveLast()
      }
    }
    
    NotificationCenter.default.addObserver(forName: .TidySplitsControllerDetailChildPopped, object: nil, queue: nil) { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.detailChilds.safeRemoveLast()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
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
    detailChilds = [controller]
    if self.currentHorizontalClass == .regular {
      if let detailNav = self.detailNavigationController {
        detailNav.setViewControllers(detailChilds as! [UIViewController], animated: animated)
        detailNav.view.layoutIfNeeded()
      } else {
        detailNavigationController = delegate?.createDetailController() ?? TidySplitsUINavigationController(.Detail)
        detailNavigationController?.view.layoutIfNeeded()
        detailNavigationController?.viewControllers = detailChilds as! [UIViewController]
      }
    } else {
      primaryNavigationController.setViewControllers((primaryChilds + detailChilds) as! [UIViewController], animated: animated)
      primaryNavigationController.view.layoutIfNeeded()
    }
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

  //Checkpoint feature.
  //TODO: Remove associated checkpoint when view controller disappear from parent! (back)
  public func goToCheckpoint(_ checkpoint: TidySplitsCheckpoint) {
    var ctrl: TidySplitsChildControllerProtocol?

    if checkpoint.childType == .Primary && primaryChilds.count > checkpoint.childIndex {
      ctrl = primaryChilds[checkpoint.childIndex]
      primaryChilds.removeSubrange(checkpoint.childIndex + 1..<primaryChilds.count)
    } else if detailChilds.count > checkpoint.childIndex {
      ctrl = detailChilds[checkpoint.childIndex]
      detailChilds.removeSubrange(checkpoint.childIndex + 1..<detailChilds.count)
    }
    
    guard let unwrappedCtrl = ctrl else {
      return
    }

    if self.currentHorizontalClass == .regular {
      if checkpoint.childType == .Primary {
        self.primaryNavigationController.popToViewController(unwrappedCtrl as! UIViewController, animated: true)
      } else {
        self.detailNavigationController?.popToViewController(unwrappedCtrl as! UIViewController, animated: true)
      }
    } else {
      self.primaryNavigationController.popToViewController(unwrappedCtrl as! UIViewController, animated: true)
    }
  }

  public func getIndex(for child: TidySplitsChildControllerProtocol) -> Int? {
    guard let childAsController = child as? UIViewController else {
      assert(false, "Child must be of type UIViewController - how you did this?")
      return nil
    }

    if child.prefferedDisplayType == .Primary {
      return primaryChilds.firstIndex(where: { (ctrl) -> Bool in
        return childAsController == ctrl as! UIViewController
      })
    } else {
      return detailChilds.firstIndex(where: { (ctrl) -> Bool in
        return childAsController == ctrl as! UIViewController
      })
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

//
//  TidySplitsUISplitViewController.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

import UIKit

open class TidySplitsUISplitViewController: UIViewController, TidySplitsNavigatorDelegate {
  public weak var delegate: TidySplitsSplitViewDelegate?

  public var navigator: TidySplitsNavigator!
    
  private var primaryWidthConstraint: NSLayoutConstraint!
  private var detailWidthConstraint: NSLayoutConstraint!
  
  /**
   Percentage value of primary stack width in **regular** layout.
   */
  open var multiplierForPrimaryRegularWidth: CGFloat {
    return 0.35
  }
  
  public var isDetailInFullscreenMode: Bool {
    return self.primaryWidthConstraint.multiplier == 1
  }
  
  public var isCollapsed: Bool {
    return self.traitCollection.horizontalSizeClass == .compact
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    assert(delegate != nil, "Delegate must not be nil!")
    
    navigator = TidySplitsNavigator(primaryChildren: delegate!.getInitialPrimaryControllers(), detailChildren: delegate!.getInitialDetailControllers(), sizeClass: self.traitCollection.horizontalSizeClass)
    navigator.delegate = self
    
    if navigator.shouldRenderInRegularLayout {
      setupRegularChildren()
    } else {
      setupCompactChildren()
    }
    
    self.setSharedPrimaryConstraints()
    self.toggleContraints()
  }
  
  override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    if newCollection.horizontalSizeClass != navigator.deviceHorizontalClass {
      navigator.deviceHorizontalClass = newCollection.horizontalSizeClass
      if navigator.shouldRenderInRegularLayout {
        computeRegularChildren()
        addChild(self.navigator.detailNavigationController!)
        view.addSubview(self.navigator.detailNavigationController!.view)
        self.navigator.detailNavigationController!.didMove(toParent: self)
        (self.navigator.primaryNavigationController.topViewController as? TidySplitsChildControllerProtocol)?.postRotateNotification(isCollapsed: false, placedAtDetailStack: false)
        (self.navigator.detailNavigationController?.topViewController as? TidySplitsChildControllerProtocol)?.postRotateNotification(isCollapsed: false, placedAtDetailStack: true)
      } else {
        self.navigator.detailNavigationController?.willMove(toParent: nil)
        self.navigator.detailNavigationController?.removeFromParent()
        self.navigator.detailNavigationController?.view.removeFromSuperview()
        computeCompactChildren()
        (self.navigator.primaryNavigationController.topViewController as? TidySplitsChildControllerProtocol)?.postRotateNotification(isCollapsed: true, placedAtDetailStack: false)
      }
      
      self.toggleContraints()
    }
  }
  
  open func createDetailController() -> TidySplitsUINavigationController {
    return TidySplitsUINavigationController(.Detail)
  }
  
  public func toggleDetailFullscreen() {
    if navigator.shouldRenderInRegularLayout {
      if self.primaryWidthConstraint.multiplier == 1 {
        self.toggleContraints(fullScreenDetail: false)
      } else {
        self.toggleContraints(fullScreenDetail: true)
      }
    }
  }
  
  private func toggleContraints(fullScreenDetail: Bool = false) {
    self.navigator.detailNavigationController?.view.translatesAutoresizingMaskIntoConstraints = false
    if navigator.shouldRenderInRegularLayout {
      primaryWidthConstraint?.isActive = false
      detailWidthConstraint?.isActive = false
      
      primaryWidthConstraint = self.navigator.primaryNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: fullScreenDetail ? 0 : self.multiplierForPrimaryRegularWidth)
      detailWidthConstraint = self.navigator.detailNavigationController!.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: fullScreenDetail ? 1 : (CGFloat(1) - self.multiplierForPrimaryRegularWidth))
      
      NSLayoutConstraint.activate(
        [primaryWidthConstraint] +
          [
            detailWidthConstraint,
            self.navigator.detailNavigationController!.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.navigator.detailNavigationController!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.navigator.detailNavigationController!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    } else {
      primaryWidthConstraint?.isActive = false
      primaryWidthConstraint = self.navigator.primaryNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor)
      primaryWidthConstraint?.isActive = true
    }
  }
  
  /**
   This method replaces current detail stack with specified controller
   
   - Parameter controller: Controller which should be placed in details stack as it's root.
   - Parameter animated: Determines if transition should be animated. Defaults to true.
   - Parameter completion: Method which should be run after details stack is replaced.
   */
  open func showDetail(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    self.navigator.showDetail(controller, animated, completion)
  }
  
  /**
   This method pushes new controller to primary or detail stack - based on controller's prefered display type.
   
   - Parameter controller: Controller to push.
   - Parameter animated: Determines if transition should be animated. Defaults to true.
   - Parameter completion: Method which should be run after push.
   */
  open func push(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) {
    self.navigator.push(controller, animated, completion)
  }
  
  open func tryPush(_ controller : UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool {
    return self.navigator.tryPush(controller, animated, completion)
  }
  
  /**
   This method pops currently displayed controller from specified type.
   
   - Parameter type: From where should we pop - Primary or Detail
   - Parameter animated: Determines if transition should be animated. Defaults to true.
   - Parameter completion: Method which should be run after pop.
   */
  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType, _ animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil) -> UIViewController? {
    return self.navigator.pop(from: type, animated, completion)
  }
  
  public var remapingInProgress: Bool {
    return self.navigator.remapingInProgress
  }
  
  public var primaryNavigationController: UINavigationController {
    return navigator.primaryNavigationController
  }
  
  public var detailNavigationController: UINavigationController? {
    return navigator.detailNavigationController
  }
  
  open func getDetailPlaceholderController() -> TidySplitsChildControllerProtocol {
    return self.delegate?.getDetailsPlaceholder() ?? TidySplitsUIViewController(.Detail)
  }
  
  private func computeCompactChildren() {
    navigator.getCompactStack(omitDetailChildren: self.delegate?.shouldOmitDetailChildrenForCompactMode ?? false)
  }
  
  private func computeRegularChildren() {
    navigator.getRegularStacks()
  }
  
  private func setupCompactChildren() {
    let compactNavCtrl = navigator.getCompactStack(omitDetailChildren: self.delegate?.shouldOmitDetailChildrenForCompactMode ?? false)
    addChildController(compactNavCtrl)
  }
  
  private func setupRegularChildren() {
    let stacks = navigator.getRegularStacks()
    addChildController(stacks.0)
    addChildController(stacks.1)
  }
  
  private func setSharedPrimaryConstraints() {
    self.navigator.primaryNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.navigator.primaryNavigationController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.navigator.primaryNavigationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.navigator.primaryNavigationController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    ])
  }
  
  fileprivate func addChildController(_ ctrl: UINavigationController) {
    addChild(ctrl)
    view.addSubview(ctrl.view)
    ctrl.didMove(toParent: self)
  }
}


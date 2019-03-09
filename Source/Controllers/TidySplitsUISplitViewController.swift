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
  private var compactPrimaryConstraints: [NSLayoutConstraint] = []
  private var regularPrimaryConstraints: [NSLayoutConstraint] = []
  
  /**
   Percentage value of primary stack width in **regular** layout.
   */
  open var multiplierForPrimaryRegularWidth: CGFloat {
    return 0.35
  }
  
  public var isCollapsed: Bool {
    return self.traitCollection.horizontalSizeClass == .compact
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    assert(delegate != nil, "Delegate must not be nil!")
    
    navigator = TidySplitsNavigator(primaryChilds: delegate!.getInitialPrimaryControllers(), detailChilds: delegate!.getInitialDetailControllers(), sizeClass: self.traitCollection.horizontalSizeClass)
    navigator.delegate = self
    
    if navigator.currentHorizontalClass == .compact {
      setupCompactChilds()
    } else {
      setupRegularChilds()
    }
    
    self.setSharedPrimaryConstraints()
    self.setCompactPrimaryConstraints()
    self.setRegularPrimaryConstraints()
    self.toggleContraints()
  }
  
  override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    if newCollection.horizontalSizeClass != navigator.currentHorizontalClass {
      navigator.currentHorizontalClass = newCollection.horizontalSizeClass
      if navigator.currentHorizontalClass == .compact {
        self.navigator.detailNavigationController?.willMove(toParent: nil)
        self.navigator.detailNavigationController?.removeFromParent()
        self.navigator.detailNavigationController?.view.removeFromSuperview()
        computeCompactChilds()
      } else {
        computeRegularChilds()
        addChild(self.navigator.detailNavigationController!)
        view.addSubview(self.navigator.detailNavigationController!.view)
        self.navigator.detailNavigationController!.didMove(toParent: self)
      }
      
      self.toggleContraints()
    }
  }
  
  open func createDetailController() -> TidySplitsUINavigationController {
    return TidySplitsUINavigationController(.Detail)
  }
  
  private func toggleContraints() {
    self.navigator.detailNavigationController?.view.translatesAutoresizingMaskIntoConstraints = false
    if navigator.currentHorizontalClass == .regular {
      NSLayoutConstraint.deactivate(compactPrimaryConstraints)
      NSLayoutConstraint.activate(
        regularPrimaryConstraints +
          [
            self.navigator.detailNavigationController!.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: CGFloat(1) - self.multiplierForPrimaryRegularWidth),
            self.navigator.detailNavigationController!.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.navigator.detailNavigationController!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.navigator.detailNavigationController!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    } else {
      NSLayoutConstraint.deactivate(regularPrimaryConstraints)
      NSLayoutConstraint.activate(compactPrimaryConstraints)
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
  
  private func computeCompactChilds() {
    navigator.getCompactStack(omitDetailChilds: self.delegate?.shouldOmitDetailChildsForCompactMode ?? false)
  }
  
  private func computeRegularChilds() {
    navigator.getRegularStacks()
  }
  
  private func setupCompactChilds() {
    let compactNavCtrl = navigator.getCompactStack(omitDetailChilds: self.delegate?.shouldOmitDetailChildsForCompactMode ?? false)
    addChildController(compactNavCtrl)
  }
  
  private func setupRegularChilds() {
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
  
  private func setRegularPrimaryConstraints() {
    self.regularPrimaryConstraints.append(contentsOf: [
      self.navigator.primaryNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: self.multiplierForPrimaryRegularWidth)
      ])
  }
  
  private func setCompactPrimaryConstraints() {
    self.compactPrimaryConstraints.append(contentsOf: [
      self.navigator.primaryNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
  }
  
  fileprivate func addChildController(_ ctrl: UINavigationController) {
    addChild(ctrl)
    view.addSubview(ctrl.view)
    ctrl.didMove(toParent: self)
  }
}


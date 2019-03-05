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

  internal var navigator: TidySplitsNavigator!
  private var compactPrimaryConstraints: [NSLayoutConstraint] = []
  private var regularPrimaryConstraints: [NSLayoutConstraint] = []
  
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
  }
  
  override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    if newCollection.horizontalSizeClass != navigator.currentHorizontalClass {
      navigator.currentHorizontalClass = newCollection.horizontalSizeClass
      if navigator.currentHorizontalClass == .compact {
        self.navigator.detailNavigationController?.willMove(toParent: nil)
        self.navigator.detailNavigationController?.removeFromParent()
        self.navigator.detailNavigationController?.view.removeFromSuperview()
        self.navigator.detailNavigationController = nil
        computeCompactChilds()
      } else {
        computeRegularChilds()
        addChild(self.navigator.detailNavigationController!)
        view.addSubview(self.navigator.detailNavigationController!.view)
        self.navigator.detailNavigationController!.didMove(toParent: self)
      }
    }
  }
  
  open override func viewWillLayoutSubviews() {
    self.navigator.detailNavigationController?.view.translatesAutoresizingMaskIntoConstraints = false
    
    if navigator.currentHorizontalClass == .regular {
      NSLayoutConstraint.deactivate(compactPrimaryConstraints)
      NSLayoutConstraint.activate(
        regularPrimaryConstraints +
          [
            self.navigator.detailNavigationController!.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            self.navigator.detailNavigationController!.view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.navigator.detailNavigationController!.view.leadingAnchor.constraint(equalTo: self.navigator.primaryNavigationController.view.trailingAnchor)
        ])
    } else {
      NSLayoutConstraint.deactivate(regularPrimaryConstraints)
      NSLayoutConstraint.activate(compactPrimaryConstraints)
    }
    
    super.viewWillLayoutSubviews()
  }
  
  open func push<TCtrl: TidySplitsChildControllerProtocol>(_ ctrl: TCtrl) {
    self.navigator.push(ctrl)
  }
  
  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType) -> UIViewController? {
    return self.navigator.pop(from: type)
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
    return self.delegate?.getDetailPlaceholderController() ?? TidySplitsUIViewController(.Detail)
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
    self.navigator.primaryNavigationController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
  }
  
  private func setRegularPrimaryConstraints() {
    self.regularPrimaryConstraints.append(contentsOf: [
      self.navigator.primaryNavigationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
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


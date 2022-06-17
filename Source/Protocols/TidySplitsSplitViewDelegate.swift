//
//  TidySplitsSplitViewDelegate.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

public protocol TidySplitsSplitViewDelegate: AnyObject {
  
  /**
   Computed get only property which decides if we should omit details stack when transitioning from **regular** to **compact** layout.
   */
  var shouldOmitDetailChildsForCompactMode: Bool { get }

  /**
  Delegate method to define which controller (or controllers) starts primary stack.
  */
  func getInitialPrimaryControllers() -> [TidySplitsChildControllerProtocol]
  
  /**
   Delegate method to define which controller (or controllers) starts detail stack.
   */
  func getInitialDetailControllers() -> [TidySplitsChildControllerProtocol]
  
  /**
   Delegate method to define which controller should be shown if detail stack is empty and we transition to **regular** "splitted" layout.
   */
  func getDetailsPlaceholder() -> TidySplitsChildControllerProtocol
}

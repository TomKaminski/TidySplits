//
//  TidySplitsSplitViewDelegate.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

public protocol TidySplitsSplitViewDelegate: class {
  var shouldOmitDetailChildsForCompactMode: Bool { get }

  func getInitialPrimaryControllers() -> [TidySplitsChildControllerProtocol]
  func getInitialDetailControllers() -> [TidySplitsChildControllerProtocol]
  func getDetailsPlaceholder() -> TidySplitsChildControllerProtocol
}

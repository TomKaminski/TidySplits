//
//  TidySplitsNavigatorDelegate.swift
//  TidySplitsExample
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

public protocol TidySplitsNavigatorDelegate: class {
  func getDetailPlaceholderController() -> TidySplitsChildControllerProtocol
}


//
//  TidySplitsNavigatorDelegate.swift
//  TidySplitsExample
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

public protocol TidySplitsNavigatorDelegate: AnyObject {
  func getDetailPlaceholderController() -> TidySplitsChildControllerProtocol
  
  /**
   Delegate method which allows to override crated TidySplitsUINavigationController.
   
   For example in this method you can disable or enable isTranslucent property of your NavigationBar.
   */
  func createDetailController() -> TidySplitsUINavigationController
}


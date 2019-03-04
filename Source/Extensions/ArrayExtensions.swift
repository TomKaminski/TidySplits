//
//  ArrayExtensions.swift
//  TidySplits
//
//  Created by Tomasz Kaminski on 3/4/19.
//  Copyright © 2019 Tomasz Kaminski. All rights reserved.
//

extension Array {
  @discardableResult public mutating func safeRemoveLast() -> Element? {
    guard !self.isEmpty else {
      return nil
    }
    
    return self.removeLast()
  }
}


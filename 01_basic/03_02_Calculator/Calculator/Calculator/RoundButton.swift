//
//  RoundButton.swift
//  Calculator
//
//  Created by Jeonggi Hong on 2021/10/28.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
  @IBInspectable var isRound: Bool = false {
    didSet {
      if isRound {
        self.layer.cornerRadius = self.frame.height / 2
      }
    }
  }
}

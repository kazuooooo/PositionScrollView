//
//  PositionScrollViewDelegate.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/08.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import UIKit

protocol PositionScrollViewDelegate {
    func onChangePage(page: Int) -> Void
    func onChangeUnit(unit: Int) -> Void
    func onChangePositionInUnit(positionInUnit: CGFloat) -> Void
    func onChangePosition(position: CGFloat) -> Void
}

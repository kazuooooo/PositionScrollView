//
//  AfterScrollMoveBehavior.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/09/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation

/// Behavior of scroll move after scroll ends
/// fitToNearestUnit: Fit nearest unit edge
/// momentum: It move until momentum disappear.
public enum AfterScrollEndsBehavior {
    case fitToNearestUnit
    case momentum
}

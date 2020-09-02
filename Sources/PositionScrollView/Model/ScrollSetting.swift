//
//  ScrollSetting.swift
//  SwiftUIInfinityScrollExample
//
//  Created by 松本和也 on 2020/04/15.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import UIKit

public struct ScrollSetting {
    
    /// How many pages in scroll
    var pageCount: Int
    
    /// InitialPage number
    var initialPage: Int
    
    /// How many units in one page
    var unitCountInPage: Int
    
    /// Behavior of scroll move after scroll ends
    /// fitToNearestUnit: Fit nearest unit edge
    /// momentum: It move until momentum disappear.
    var afterMoveType: AfterScrollEndsBehavior = .momentum
    
    /// Scroll speed threshold to detect
    var scrollSpeedToDetect: Double
    
    /// Delegate Scroll Event
    public var positionScrollDelegate: PositionScrollViewDelegate?
    
    public init(
        pageCount: Int,
        initialPage: Int = 0,
        unitCountInPage: Int = 1,
        afterMoveType: AfterScrollEndsBehavior = .momentum,
        scrollSpeedToDetect: Double = 30
    ) {
        self.pageCount = pageCount
        self.initialPage = initialPage
        self.unitCountInPage = unitCountInPage
        self.afterMoveType = afterMoveType
        self.scrollSpeedToDetect = scrollSpeedToDetect
    }
}

/// Behavior of scroll move after scroll ends
/// fitToNearestUnit: Fit nearest unit edge
/// momentum: It move until momentum disappear.
public enum AfterScrollEndsBehavior {
    case fitToNearestUnit
    case momentum
}

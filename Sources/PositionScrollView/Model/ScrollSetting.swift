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
    
    /// Width and height of one page, basically it is the same as PositionScrollVIew frame size.
    var pageLength: CGFloat
    
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
        pageSize: CGFloat,
        unitCountInPage: Int = 1,
        afterMoveType: AfterScrollEndsBehavior = .momentum,
        scrollSpeedToDetect: Double = 30
    ) {
        self.pageCount = pageCount
        self.initialPage = initialPage
        self.pageLength = pageSize
        self.unitCountInPage = unitCountInPage
        self.afterMoveType = afterMoveType
        self.scrollSpeedToDetect = scrollSpeedToDetect
    }
    
    /// Length of single unit
    var unitLength: CGFloat {
        pageLength / CGFloat(unitCountInPage)
    }
    
    /// Total length of scrollView
    var contentSize: CGFloat {
        pageLength * CGFloat(pageCount)
    }
    
    /// Movable range of scroll position
    var movableRangeOfScroll: ClosedRange<CGFloat> {
        0...(contentSize - pageLength)
    }
    
}

/// Behavior of scroll move after scroll ends
/// fitToNearestUnit: Fit nearest unit edge
/// momentum: It move until momentum disappear.
public enum AfterScrollEndsBehavior {
    case fitToNearestUnit
    case momentum
}

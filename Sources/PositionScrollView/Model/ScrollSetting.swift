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
    
    /// initialPage number
    var initialPage: Int
    
    /// Width and height of one page, basically it is the same as PositionScrollVIew frame size.
    var pageSize: CGFloat
    
    /// How many units in one page
    var unitCountInPage: Int
    
    /// Behaviour after finger release.
    /// .smooth: Move follows ineritia
    /// .unit: Move to nearest unit position
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
        self.pageSize = pageSize
        self.unitCountInPage = unitCountInPage
        self.afterMoveType = afterMoveType
        self.scrollSpeedToDetect = scrollSpeedToDetect
    }
    
    var unitSize: CGFloat {
        pageSize / CGFloat(unitCountInPage)
    }
    
    var contentSize: CGFloat {
        pageSize * CGFloat(pageCount)
    }
    
    var pageZeroOffset: CGFloat {
        contentSize / 2 - pageSize / 2
    }
    
    var positionRange: ClosedRange<CGFloat> {
        0...(contentSize - pageSize)
    }
    
}

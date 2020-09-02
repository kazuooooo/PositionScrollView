//
//  PositionScrollViewDelegate.swift
//
//  Created by 松本和也 on 2020/04/08.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import UIKit

/**
 PositionScrollView Delegate.
 Please define this delegate to monitor scroll state in your code.
 */
public protocol PositionScrollViewDelegate {
    
    /// Called when a scroll starts.
    func onScrollStart() -> Void
    
    /// Called when scroll page changed
    /// - Parameter page: Page number
    func onChangePage(page: Int) -> Void
    
    /// Called when unit changed.
    /// - Parameter unit: Unit number
    func onChangeUnit(unit: Int) -> Void
    
    /// Called when position in page changed.
    /// - Parameter positionInpage: Position in unit float value
    func onChangePositionInPage(positionInPage: CGFloat) -> Void
    
    /// Called when position in unit changed.
    /// - Parameter positionInUnit: Position in unit float value
    func onChangePositionInUnit(positionInUnit: CGFloat) -> Void
    
    
    /// Called when position changed.
    /// - Parameter position: Position float value
    func onChangePosition(position: CGFloat) -> Void
    
    /// Called when a scroll ends.
    func onScrollEnd() -> Void
}

// Empty default methods defined to make method optional.
extension PositionScrollViewDelegate {
    public func onScrollStart(){}
    func onChangePage(page: Int) -> Void {}
    public func onChangeUnit(unit: Int) -> Void {}
    public func onChangePositionInPage(positionInPage: CGFloat) -> Void {}
    public func onChangePositionInUnit(positionInUnit: CGFloat) -> Void {}
    func onChangePosition(position: CGFloat) -> Void {}
    func onScrollEnd() -> Void {}
}

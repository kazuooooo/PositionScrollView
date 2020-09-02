//
//  PositionScrollViewModel.swift
//  ViewModel for PositoinScrollView
//  Manage dimentional scroll state by holding horizontalScroll & verticalScroll
//  Created by 松本和也 on 2020/03/28.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import SwiftUI

/**
 ViewModel of PositoinScrollView
 */
public class PositionScrollViewModel: ObservableObject {
    
    /// Dimentional
    @Published public var horizontalScroll: Scroll?
    @Published public var verticalScroll: Scroll?

    /// Currently  active scroll
    var activeScroll: Scroll? {
        get {
            switch activeScrollDirection {
            case .horizontal:
                return self.horizontalScroll
            case .vertical:
                return self.verticalScroll
            case .none:
                return nil
            }
        }
        set {
            switch activeScrollDirection {
            case .horizontal:
                self.horizontalScroll = newValue
            case .vertical:
                self.verticalScroll = newValue
            case .none:
                return
            }
        }
    }
    
    // Direction of current scroll
    var activeScrollDirection: ScrollDirection? {
        didSet {
            switch activeScrollDirection {
            case .horizontal:
                self.horizontalScroll?.scrollSetting.positionScrollDelegate?.onScrollStart()
            case .vertical:
                self.verticalScroll?.scrollSetting.positionScrollDelegate?.onScrollStart()
            case .none:
                return
            }
        }
    }
    
    var isScrolling: Bool { self.activeScrollDirection != nil }
    
    /// CGSize of single page
    var pageSize: CGSize
    
    var scrollDetector: ScrollDetector
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - pageSize: pageSize
    ///   - horizontalScroll: ScrollObject for Horizontal
    ///   - verticalScroll: ScrollObject for Vertical
    /// - Note:
    ///   If scroll object is nil, the direction can not be scrolled.
    /// - SeeAlso:
    ///   Scroll.swift
    public init(
        pageSize: CGSize,
        horizontalScroll: Scroll? = nil,
        verticalScroll: Scroll? = nil
    ){
        self.pageSize = pageSize
        self.scrollDetector = ScrollDetector(
            horizontalScrollSpeedToDetect: horizontalScroll?.scrollSpeedToDetect, verticalScrollSpeedToDetect: verticalScroll?.scrollSpeedToDetect
        )
        self.horizontalScroll = horizontalScroll
        self.verticalScroll = verticalScroll
    }
    
    /// Detect scroll by drag speed
    ///
    /// - Parameter dragValue: dragValue from PositionScrollView
    /// - Returns: Bool as ScrollDetection
    internal func detectScroll(
        dragValue: DragGesture.Value
    ) -> Bool {
        if(self.isScrolling){
            return true
        }
        if let scrollDirection = self.scrollDetector.detectScroll(
            currentDragValue: dragValue
            ) {
            switch scrollDirection {
            case .horizontal:
                self.activeScrollDirection = .horizontal
            case .vertical:
                self.activeScrollDirection = .vertical
            }
            print("detect")
            return true
        } else {
            print("not detect")
            return false
        }
    }
    
    /// Handle scroll while scrolling. Move by dragValue.
    ///
    /// - Parameter dragValue: dragValue
    internal func handleScroll(dragValue: DragGesture.Value){
        guard let scrollDirection = self.activeScrollDirection else {
            return
        }
        let directionDragValue = Scroll.dragValueForScrollDirection(
            dragValue: dragValue,
            scrollDirection: scrollDirection
        )
        self.activeScroll?.moveBy(value: -(directionDragValue))
        // NOTE: 無限スクロールでScrollクラスを継承したい(変数を定義したい)
        //       都合上Scrollをクラスにしてクラスの変更をobjectWillChange.send()で通知するようにしている。
        self.objectWillChange.send()
    }
    
    /// Handle scroll end. Reset scroll state and move to endPosition.
    ///
    /// - Parameter endDragValue: endDragValue of scroll
    internal func handleScrollEnd(endDragValue: DragGesture.Value) {
        guard let scrollDirection = self.activeScrollDirection else {
                   return
               }
        let directionendDragValue = Scroll.endDragValueForScrollDirection(endDragValue: endDragValue, scrollDirection: scrollDirection)
        
        guard let scrollEndPosition = self.activeScroll?.calcScrollEndPosition(predictedEndValue: directionendDragValue) else {
            return
        }
        withAnimation(.easeOut) {
            // NOTE: moveToの後にobjectWillChangeを呼ぶとなぜか画面がかくつくのでこの順序は変更しないこと。
            self.objectWillChange.send()
            self.activeScroll?.moveTo(position: scrollEndPosition)
        }
        self.activeScroll?.end()
        self.activeScrollDirection = nil
        self.scrollDetector.reset()
    }
}

//
//  ScrollState.swift
//  InfinityScrollDev
//
//  Created by 松本和也 on 2020/03/28.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import SwiftUI

public class ScrollState: ObservableObject {
    
    /// Dimentional
    @Published var horizontalScroll: Scroll?
    @Published var verticalScroll: Scroll?

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
    var activeScrollDirection: ScrollDirection?
    var isScrolling: Bool { self.activeScrollDirection != nil }
    /// pageSize means width, height size of scrollview
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
    init(
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
        let directionDragValue = Scroll.dragValueForDirection(dragValue: dragValue, scrollDirection: scrollDirection)
        self.activeScroll?.moveBy(value: directionDragValue)
    }
    
    /// Handle scroll end. Reset scroll state and move to endPosition.
    ///
    /// - Parameter endDragValue: endDragValue of scroll
    func handleScrollEnd(endDragValue: DragGesture.Value) {
        guard let scrollDirection = self.activeScrollDirection else {
                   return
               }
        let directionendDragValue = Scroll.endDragValueForDirection(endDragValue: endDragValue, scrollDirection: scrollDirection)
        
        guard let scrollEndPosition = self.activeScroll?.calcScrollEndPosition(predictedEndValue: directionendDragValue) else {
            return
        }
        withAnimation(.easeOut) {
            self.activeScroll?.moveTo(position: scrollEndPosition)
            self.activeScroll?.end()
        }
        self.activeScrollDirection = nil
        self.scrollDetector.reset()
    }
}

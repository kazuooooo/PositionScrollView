//
//  DragVelocityCalculator.swift
//  ScrollTest
//
//  Created by 松本和也 on 2020/01/30.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import SwiftUI

/**
 * Detector of Scroll
 * From the current DragValue, detect  scroll direction and its direction.
 */
internal class ScrollDetector{
    
    /// Threshold for horizontal scroll
    var horizontalScrollSpeedToDetect: Double?
    
    /// Threshold for vertical scroll
    var verticalScrollSpeedToDetect: Double?
    
    init(
        horizontalScrollSpeedToDetect: Double?,
        verticalScrollSpeedToDetect: Double?
    ){
        self.horizontalScrollSpeedToDetect = horizontalScrollSpeedToDetect
        self.verticalScrollSpeedToDetect = verticalScrollSpeedToDetect
    }
    
    // To calc dragspeed, it needs previousDragValue
    private var previousDragValue: DragGesture.Value?
    
    /// Detect scroll
    /// - Parameter currentDragValue: currentDragvValue
    /// - Returns: Scroll direction horizontal or vertical
    func detectScroll(
        currentDragValue: DragGesture.Value
    ) -> ScrollDirection? {
        
        // Firsttime, set previousDragValue and return.
        guard let previousDragValue = previousDragValue else {
            self.previousDragValue = currentDragValue
            return nil
        }
        
        // CalcDragValue
        let velocity = calcDragVelocity(
            previousDragValue: previousDragValue,
            currentDragValue: currentDragValue
        )
        
        let horizontalScrollSpeed = abs(velocity.x)
        let verticalScrollSpeed   = abs(velocity.y)

        if(horizontalScrollSpeed > verticalScrollSpeed) {
            // check horizontal
            guard let hThreshold = horizontalScrollSpeedToDetect else {
                return nil
            }
            if(horizontalScrollSpeed > hThreshold) {
                return .horizontal
            }
        } else {
            // check vertical
            guard let vThreshold = verticalScrollSpeedToDetect else {
                return nil
            }
            if(verticalScrollSpeed > vThreshold) {
                return .vertical
            }
        }
        return nil
    }
    
    /// Init detector state
    func reset(){
        self.previousDragValue = nil
    }
    
    /// Calcurate vertical, horizontal velocity of current drag
    private func calcDragVelocity(
        previousDragValue: DragGesture.Value,
        currentDragValue: DragGesture.Value
    ) -> (x: Double, y: Double) {
        let timeInterval = currentDragValue.time.timeIntervalSince(previousDragValue.time)
        
        let diffXInTimeInterval = Double(currentDragValue.translation.width - previousDragValue.translation.width)
        let diffYInTimeInterval = Double(currentDragValue.translation.height - previousDragValue.translation.height)
        
        let velocityX = diffXInTimeInterval / timeInterval
        let velocityY = diffYInTimeInterval / timeInterval
        return (x: velocityX, y: velocityY)
    }
}

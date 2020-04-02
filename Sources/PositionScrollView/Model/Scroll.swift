import Foundation
import UIKit
import SwiftUI
/// Scroll class
/// encapsulates information about scroll
/// To controll position easily, Scroll class use page and unit.
/// page: TODO
/// unit: TODO
/// Note: This class doesn't  care for scroll direction.
struct Scroll {
    /// How many pages in scroll
    var pageCount: Int
    
    /// Width and height of one page, basically it is the same as PositionScrollVIew frame size.
    var pageSize: CGFloat
    
    /// How many units in one page
    var unitCountInPage: Int
    
    /// Behaviour after finger release.
    /// .smooth: Move follows ineritia
    /// .unit: Move to nearest unit position
    var afterMoveType: AfterMoveType
    
    /// Scroll speed threshold to detect
    var scrollSpeedToDetect: Double
    
    private var lastPosition: CGFloat
    
    private var unitSize: CGFloat {
        pageSize / CGFloat(unitCountInPage)
    }
    
    private var contentSize: CGFloat {
        pageSize * CGFloat(pageCount)
    }
    
    private var pageZeroOffset: CGFloat {
        contentSize / 2 - pageSize / 2
    }
    
    private var positionRange: ClosedRange<CGFloat> {
        0...(contentSize - pageSize)
    }
    
    // 0ページ目の端を基準にしたposition
    private var position: CGFloat {
        get { pageToPosition(page: page, unit: unit, positionInUnit: positionInUnit) }
        // page = 600
        // unit = 300
        // newValue = 1230の場合
        // page = 1530 / 600 = 2
        // unit = (1530 - (page * pageSize)) / 300 = 1
        // positionInUnit = 1530 - page * pageSize - unit * unitSize
        set {
            self.page = Int(newValue / pageSize)
            let unitValue = Double(newValue).truncatingRemainder(dividingBy: Double(pageSize))
            self.unit = Int(unitValue / Double(unitSize))
            self.positionInUnit = CGFloat(Double(unitValue).truncatingRemainder(dividingBy: Double(unitSize)))
        }
    }
    
    // position for Zstack
    var zStackPosition: CGFloat {
        -(position + pageSize / 2 - contentSize / 2)
    }
    
    //
    private var page: Int = 0
    private var unit: Int = 0
    private var positionInUnit: CGFloat = 0
    
    init(
        pageCount: Int,
        pageSize: CGFloat,
        unitCountInPage: Int = 1,
        initialPage: Int = 0,
        initialUnit: Int = 0,
        initialPositionInUnit: CGFloat = 0,
        lastScrollPosition: CGFloat = 0,
        afterMoveType: AfterMoveType = .smooth,
        scrollSpeedToDetect: Double = 30
    ){
        self.pageCount = pageCount
        self.pageSize = pageSize
        self.unitCountInPage = unitCountInPage
        self.page = initialPage
        self.unit = initialUnit
        self.positionInUnit = initialPositionInUnit
        self.lastPosition = lastScrollPosition
        self.afterMoveType = afterMoveType
        self.scrollSpeedToDetect = scrollSpeedToDetect
    }
    
    
    /// Move scroll by argment value
    /// - Parameter value: Value to move
    mutating func moveBy(value: CGFloat) {
        let newPosition = lastPosition - value
        self.position = self.correctPosition(position: newPosition)
    }
    
    /// Move scroll to argment position
    /// - Parameter position: Position to move
    mutating func moveTo(position: CGFloat) {
        self.position = self.correctPosition(position: position)
    }
    
    /// End scroll
    mutating func end() {
        self.lastPosition = position
    }
    
    /// Calculate scroll endposition based on AfterScroMoveType
    ///
    /// .smooth: Move follows ineritia
    /// .unit: Move to nearest unit position
    /// - Parameter predictedEndValue: Predicted scroll end value by ineritia
    /// - Returns: Scroll end position
    func calcScrollEndPosition(predictedEndValue: CGFloat) -> CGFloat {
        switch afterMoveType {
        case .smooth:
            return position - predictedEndValue
        case .unit:
            if positionInUnit < unitSize / 2 {
                return pageToPosition(page: page, unit: unit, positionInUnit: 0)
            } else {
                return pageToPosition(page: page, unit: unit+1, positionInUnit: 0)
            }
        }
    }
    
    /// Correct position of scroll in pages min/Max range.
    ///
    /// - Parameter position: Raw position
    /// - Returns: Corrected position
    private func correctPosition(position: CGFloat) -> CGFloat {
        if(position < positionRange.lowerBound) {
            return positionRange.lowerBound
        }
        if(position > positionRange.upperBound) {
            return positionRange.upperBound
        }
        return position
    }
    
    /// Convert page/unit position to zIndexPosition
    /// - Parameters:
    ///   - page: <#page description#>
    ///   - unit: <#unit description#>
    ///   - positionInUnit: <#positionInUnit description#>
    /// - Returns: <#description#>
    private func pageToPosition(page: Int, unit: Int, positionInUnit: CGFloat) -> CGFloat {
        CGFloat(page) * pageSize + CGFloat(unit) * unitSize + positionInUnit
    }
}

extension Scroll {
    static func dragValueForDirection(dragValue: DragGesture.Value, scrollDirection: ScrollDirection) -> CGFloat {
        switch scrollDirection {
        case .horizontal:
            return dragValue.translation.width
        case .vertical:
            return dragValue.translation.height
        }
    }

    static func endDragValueForDirection(endDragValue: DragGesture.Value, scrollDirection: ScrollDirection) -> CGFloat {
        switch scrollDirection {
        case .horizontal:
            return endDragValue.predictedEndTranslation.width
        case .vertical:
            return endDragValue.predictedEndTranslation.height
        }
    }
}

enum ScrollDirection {
    case horizontal
    case vertical
}

enum AfterMoveType {
    case unit   // unitごとにスクロールさせる
    case smooth // 通常の慣性スクロール
}

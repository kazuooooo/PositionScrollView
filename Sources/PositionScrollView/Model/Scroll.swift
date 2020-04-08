import Foundation
import UIKit
import SwiftUI
/// Scroll class
/// encapsulates information about scroll
/// To controll position easily, Scroll class use page and unit.
/// page: TODO
/// unit: TODO
/// Note: This class doesn't  care for scroll direction.

struct ScrollSetting {
    /// How many pages in scroll
    var pageCount: Int
    
    /// Width and height of one page, basically it is the same as PositionScrollVIew frame size.
    var pageSize: CGFloat
    
    /// How many units in one page
    var unitCountInPage: Int = 1
    
    /// Behaviour after finger release.
    /// .smooth: Move follows ineritia
    /// .unit: Move to nearest unit position
    var afterMoveType: AfterMoveType = .smooth
    
    /// Scroll speed threshold to detect
    var scrollSpeedToDetect: Double = 30
    
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
    
    var positionScrollDelegate: PositionScrollViewDelegate?
}

struct Scroll {
    var scrollSetting: ScrollSetting
    private var lastPosition: CGFloat = 0
    
    // delegate to scrollsetting
    var pageSize: CGFloat { scrollSetting.pageSize }
    var unitSize: CGFloat { scrollSetting.unitSize }
    var contentSize: CGFloat { scrollSetting.contentSize }
    var pageZeroOffset: CGFloat { scrollSetting.pageZeroOffset }
    var positionRange: ClosedRange<CGFloat> { scrollSetting.positionRange }
    var scrollSpeedToDetect: Double { scrollSetting.scrollSpeedToDetect }
    
    // 0ページ目の端を基準にしたposition
    var position: CGFloat {
        get { pageToPosition(page: page, unit: unit, positionInUnit: positionInUnit) }
        // page = 600
        // unit = 300
        // newValue = 1230の場合
        // page = 1530 / 600 = 2
        // unit = (1530 - (page * pageSize)) / 300 = 1
        // positionInUnit = 1530 - page * pageSize - unit * unitSize
        set {
            if newValue != position {
                self.scrollSetting.positionScrollDelegate?.onChangePosition(position: position)
            }
            self.page = Int(newValue / pageSize)
            let unitValue = Double(newValue).truncatingRemainder(dividingBy: Double(pageSize))
            self.unit = Int(unitValue / Double(unitSize))
            self.positionInUnit = CGFloat(Double(unitValue).truncatingRemainder(dividingBy: Double(unitSize)))
        }
    }
    
    // position for Zstack
    var zStackPosition: CGFloat {
        -(position + scrollSetting.pageSize / 2 - scrollSetting.contentSize / 2)
    }
    
    //
    var page: Int = 0 {
        // NOTE: これだとちょっとタイミングが早すぎるかも...
        didSet {
            if page != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangePage(page: page)
            }
        }
    }
    var unit: Int = 0 {
        didSet {
            if unit != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangeUnit(unit: unit)
            }
        }
    }
    var positionInUnit: CGFloat = 0 {
        didSet {
            if positionInUnit != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangePositionInUnit(positionInUnit: positionInUnit)
            }
        }
    }
    
    init(
        scrollSetting: ScrollSetting,
        initialPage: Int = 0,
        initialUnit: Int = 0,
        initialPositionInUnit: CGFloat = 0
    ){
        self.scrollSetting = scrollSetting
        self.page = initialPage
        self.unit = initialUnit
        self.positionInUnit = initialPositionInUnit
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
        switch scrollSetting.afterMoveType {
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

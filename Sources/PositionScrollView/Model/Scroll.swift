import Foundation
import UIKit
import SwiftUI
/**
 * Scroll encapsulates information about scroll
 * To controll position easily, Scroll class use page and unit.
 * To see more detail, please read README.md.
 * Note: This class doesn't  care for scroll direction.
 */
public class Scroll: ObservableObject {
    /// Scroll setting
    public var scrollSetting: ScrollSetting
    /// Store last position
    private var lastPosition: CGFloat = 0
    
    /// Delegate to scrollsetting
    var pageSize: CGFloat { scrollSetting.pageLength }
    var unitSize: CGFloat { scrollSetting.unitLength }
    var contentSize: CGFloat { scrollSetting.contentSize }
    var positionRange: ClosedRange<CGFloat> { scrollSetting.movableRangeOfScroll }
    var scrollSpeedToDetect: Double { scrollSetting.scrollSpeedToDetect }
    
    /// Position based on the start of page 0
    var position: CGFloat {
        get { pageToPosition(page: page, unit: unit, positionInUnit: positionInUnit) }

        set {
            if newValue != position {
                self.scrollSetting.positionScrollDelegate?.onChangePosition(position: position)
            }
            
            /*
              Set position related variables based on new position raw value.
              ex) pageSize = 600, unitSize = 300, newValue = 1730
              page = 1730 / 600 = 2
              positionInPage = 1730 % 600 = 530
              unit = 530 / 300 = 1
              positionInUnit = 530 % 300 = 230
             
              So
              page = 2, positionInPage = 530
              unit = 1, positionInUnit = 230
             */
            self.page = Int(newValue / pageSize)
            self.positionInPage = CGFloat(Double(newValue).truncatingRemainder(dividingBy: Double(pageSize)))
            self.unit = Int(Double(self.positionInPage) / Double(unitSize))
            self.positionInUnit = CGFloat(Double(self.positionInPage).truncatingRemainder(dividingBy: Double(unitSize)))
        }
    }
    
    /// Position for Zstack using in view.
    var zStackPosition: CGFloat {
        -(position + scrollSetting.pageLength / 2 - scrollSetting.contentSize / 2)
    }
    
    /// Current page
    var page: Int = 0 {
        // NOTE: Timing mingt be too fast
        didSet {
            if page != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangePage(page: page)
            }
        }
    }
    
    /// Current position in page
    var positionInPage: CGFloat = 0 {
        didSet {
            if positionInPage != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangePositionInPage(positionInPage: positionInPage)
            }
        }
    }
    
    /// Current unit in page
    var unit: Int = 0 {
        didSet {
            if unit != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangeUnit(unit: unit)
            }
        }
    }
    
    /// Current position in unit
    var positionInUnit: CGFloat = 0 {
        didSet {
            if positionInUnit != oldValue {
                self.scrollSetting.positionScrollDelegate?.onChangePositionInUnit(positionInUnit: positionInUnit)
            }
        }
    }
    
    public init(
        scrollSetting: ScrollSetting
    ){
        self.scrollSetting = scrollSetting
        self.page = scrollSetting.initialPage
        self.lastPosition = pageToPosition(page: page, unit: unit, positionInUnit: positionInUnit)
    }
    
    /// Move scroll by argment value
    /// - Parameter value: Value to move
    func moveBy(value: CGFloat) {
        let newPosition = self.lastPosition + value
        self.position = self.correctPositionInRange(position: newPosition)
    }
    
    /// Move scroll to argment position
    /// - Parameter position: Position to move
    func moveTo(position: CGFloat) {
        self.position = self.correctPositionInRange(position: position)
    }
    
    // MovePositionToPage
    public func moveToPage(page: Int, unit: Int = 0, positionInUnit: CGFloat = 0) {
        let position = pageToPosition(
            page: page,
            unit: unit,
            positionInUnit: positionInUnit
        )
        self.moveTo(position: position)
    }
    
    /// End scroll
    public func end() {
        self.lastPosition = position
        self.scrollSetting.positionScrollDelegate?.onScrollEnd()
    }
    
    /// Calculate scroll endposition based on AfterScrollEndsBehavior
    /// - Parameter predictedEndValue: Predicted scroll end value by ineritia
    /// - Returns: Scroll end position
    func calcScrollEndPosition(predictedEndValue: CGFloat) -> CGFloat {
        switch scrollSetting.afterMoveType {
        case .momentum:
            return position - predictedEndValue
        case .fitToNearestUnit:
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
    internal func correctPositionInRange(position: CGFloat) -> CGFloat {
        if(position < positionRange.lowerBound) {
            return positionRange.lowerBound
        }
        if(position > positionRange.upperBound) {
            return positionRange.upperBound
        }
        return position
    }
    
    /// Convert page/unit position.
    private func pageToPosition(page: Int, unit: Int, positionInUnit: CGFloat) -> CGFloat {
        CGFloat(page) * pageSize + CGFloat(unit) * unitSize + positionInUnit
    }
}

extension Scroll {
    static func dragValueForScrollDirection(
        dragValue: DragGesture.Value,
        scrollDirection: ScrollDirection
    ) -> CGFloat {
        switch scrollDirection {
        case .horizontal:
            return dragValue.translation.width
        case .vertical:
            return dragValue.translation.height
        }
    }

    static func endDragValueForScrollDirection(
        endDragValue: DragGesture.Value,
        scrollDirection: ScrollDirection
    ) -> CGFloat {
        switch scrollDirection {
        case .horizontal:
            return endDragValue.predictedEndTranslation.width
        case .vertical:
            return endDragValue.predictedEndTranslation.height
        }
    }
}

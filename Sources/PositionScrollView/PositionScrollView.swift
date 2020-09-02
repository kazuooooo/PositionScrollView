import SwiftUI

/// Extended ScrollView which can controll position
public struct PositionScrollView<ChildView: View>: View {
    
    /// View model
    @ObservedObject var viewModel: PositionScrollViewModel
    
    /// Mask with single page size.
    let mask: Bool
    
    /// Scroll target view
    let childView: ChildView
    
    
    /// Initializer
    /// - Parameters:
    ///   - pageSize: Size of Page
    ///   - horizontalScrollSetting: Scroll setting for horizontal direction
    ///   - verticalScrollSetting: Scroll setting for vertical direction
    ///   - delegate: PositionScrollViewDelegate
    ///   - mask: Mask with single page size. Default false.
    ///   - childView: Scroll target view
    public init(
        pageSize: CGSize,
        horizontalScrollSetting: ScrollSetting? = nil,
        verticalScrollSetting: ScrollSetting? = nil,
        delegate: PositionScrollViewDelegate? = nil,
        mask: Bool = false,
        _ childView: () -> (ChildView)
    ) {
        self.childView = childView()
        self.mask = mask
        
        // Throw Error when no scroll setting
        if(horizontalScrollSetting == nil && verticalScrollSetting == nil) {
            fatalError("No scroll setting found, please set horizontal or vertical ScrollSetting")
        }
        
        let hScroll = horizontalScrollSetting != nil ? Scroll(scrollSetting: horizontalScrollSetting!, pageLength: pageSize.width) : nil
        let vScroll = verticalScrollSetting != nil ? Scroll(scrollSetting: verticalScrollSetting!, pageLength: pageSize.height) : nil
        
        self.viewModel = PositionScrollViewModel(
            pageSize: pageSize,
            horizontalScroll: hScroll,
            verticalScroll: vScroll
        )
        
        self.viewModel.horizontalScroll?.scrollSetting.positionScrollDelegate = delegate
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            self.childView.frame(alignment: .topLeading)
                .position(
                    x: viewModel.horizontalScroll?.zStackPosition ?? 0,
                    y: viewModel.verticalScroll?.zStackPosition ?? 0
            ).offset(
                // NOTE: Offset to correct the cordinate to upper left of a PositionScrollView.
                x: viewModel.pageSize.width / 2,
                y: viewModel.pageSize.height / 2
            ).if(mask) { content in
                // Mask with Single Page Rectangle
                content.mask(
                    Rectangle().frame(
                        width: viewModel.pageSize.width,
                        height: viewModel.pageSize.height
                    )
                )
            }
        }.gesture(DragGesture().onChanged {value in
            // TODO: このif分viewModel内に入れたいが厳しいかも
            if (self.viewModel.detectScroll(dragValue: value)) {
                self.viewModel.handleScroll(dragValue: value)
            }
        }.onEnded{endDragValue in
            self.viewModel.handleScrollEnd(endDragValue: endDragValue)
        })
            .frame(
                width: viewModel.pageSize.width,
                height: viewModel.pageSize.height
        )
    }
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional {
            return TupleView((nil, content(self)))
        } else {
            return TupleView((self, nil))
        }
    }
}

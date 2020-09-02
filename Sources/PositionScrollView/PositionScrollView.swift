import SwiftUI

/// Extended ScrollView which can controll position
public struct PositionScrollView<ChildView: View>: View {
    
    /// View model
    // 😢FIXME😢:
    /*
     Originally, I want to create viewModel in this Class not passed from parent view.
     But if I do that, PositionScrollView is undesirably reset when parent view's state is updated.
    */
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
        viewModel: PositionScrollViewModel,
        mask: Bool = false,
        delegate: PositionScrollViewDelegate?,
        _ childView: () -> (ChildView)
    ) {
        self.childView = childView()
        self.mask = mask
        self.viewModel = viewModel
        
        // Set delegate
        if let pDelegate = delegate {
            if(viewModel.horizontalScroll != nil) {
                viewModel.horizontalScroll?.scrollSetting.positionScrollDelegate = pDelegate
            }
            if(viewModel.verticalScroll != nil) {
                viewModel.verticalScroll?.scrollSetting.positionScrollDelegate = pDelegate
            }
        }
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

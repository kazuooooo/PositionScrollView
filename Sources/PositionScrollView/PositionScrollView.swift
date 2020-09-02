import SwiftUI

/// Extended ScrollView which can controll position
public struct PositionScrollView<ChildView: View>: View {
    @ObservedObject private var viewModel: PositionScrollViewModel
    let mask: Bool
    
    /// Scroll target view
    let childView: ChildView
    
    /// - Parameters:
    ///   - viewModel: positionScrollViewModel
    ///   - mask: Only visible single page by mask
    ///   - childView: Scroll target view
    public init(
        viewModel: PositionScrollViewModel,
        mask: Bool = false,
        _ childView: () -> (ChildView)
    ) {
        self.childView = childView()
        self.mask = mask
        self.viewModel = viewModel
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

struct PositionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let pageSize = CGSize(
            width: 200,
            height: 200
        )
        
        let scrollSetting = ScrollSetting(
            pageCount: 2,
            initialPage: 0,
            pageSize: 200,
            afterMoveType: .momentum
        )
        
        let viewModel = PositionScrollViewModel(
            pageSize: pageSize,
            horizontalScroll: Scroll(
                scrollSetting: scrollSetting
            )
        )
        
        return PositionScrollView(
            viewModel: viewModel
        ) {
            HStack(spacing: 0) {
                ZStack {
                    Image("image").resizable().frame(width: 200, height: 200)
                    Text("0")
                }.border(Color.red)
                ZStack {
                    Image("image").resizable().frame(width: 200, height: 200)
                    Text("1")
                }
            }
        }
    }
}

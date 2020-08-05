import SwiftUI

/// Extended ScrollView which can controll position
public struct PositionScrollView<ChildView: View>: View {
    @ObservedObject var scrollState: ScrollState
    let mask: Bool
    
    /// Scroll target view
    let childView: ChildView
    
    /// - Parameters:
    ///   - scrollState: scroll state
    ///   - mask: Only visible single page by mask
    ///   - childView: Scroll target view
    public init(
        scrollState: ScrollState,
        mask: Bool = false,
        _ childView: () -> (ChildView)
    ) {
        self.childView = childView()
        self.mask = mask
        self.scrollState = scrollState
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            self.childView.frame(alignment: .topLeading)
                .position(
                    x: self.scrollState.horizontalScroll?.zStackPosition ?? 0,
                    y: self.scrollState.verticalScroll?.zStackPosition ?? 0
            ).offset(
                // NOTE: Offset to correct the cordinate to upper left of a PositionScrollView.
                x: self.scrollState.pageSize.width / 2,
                y: self.scrollState.pageSize.height / 2
            ).if(mask) { content in
                content.mask(
                    Rectangle().frame(width: self.scrollState.pageSize.width, height: scrollState.pageSize.height)
                )
            }
        }.gesture(DragGesture().onChanged {value in
            if (self.scrollState.detectScroll(dragValue: value)) {
                self.scrollState.handleScroll(dragValue: value)
            }
        }.onEnded{endDragValue in
            self.scrollState.handleScrollEnd(endDragValue: endDragValue)
        })
            .frame(
                width: self.scrollState.pageSize.width,
                height: self.scrollState.pageSize.height
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
            afterMoveType: .unit
        )
        
        let scrollState = ScrollState(
            pageSize: pageSize,
            horizontalScroll: Scroll(
                scrollSetting: scrollSetting
            )
        )
        
        return PositionScrollView(
            scrollState: scrollState
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

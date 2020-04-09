import SwiftUI

/// Extended ScrollView which can controll position
public struct PositionScrollView<ChildView: View>: View {
    @ObservedObject var scrollState: ScrollState
    /// Scroll target view
    let childView: ChildView
    
    /// - Parameters:
    ///   - scrollState: scroll state
    ///   - childView: Scroll target view
    init(
        scrollState: ScrollState,
        _ childView: () -> (ChildView)
    ) {
        self.childView = childView()
        self.scrollState = scrollState
    }
    
    // Horizontal Only
//    init(
//        pageSize: CGSize,
//        horizontalScrollSetting: ScrollSetting,
//        positionScrollViewDelegate: PositionScrollViewDelegate? = nil,
//        _ childView: () -> (ChildView)) {
//        let scrollState = ScrollState(
//            pageSize: pageSize,
//            horizontalScroll: Scroll(scrollSetting: horizontalScrollSetting)
//        )
//        self.init(scrollState: scrollState, childView)
//    }
//
    // Vertical Only
//    init(
//        pageSize: CGSize,
//        verticalScrollSetting: ScrollSetting,
//        positionScrollViewDelegate: PositionScrollViewDelegate? = nil,_ childView: () -> (ChildView)) {
//        let scrollState = ScrollState(
//            pageSize: pageSize,
//            verticalScroll: Scroll(
//                scrollSetting: verticalScrollSetting
//            )
//        )
//        self.init(scrollState: scrollState, childView)
//    }
//
//    // Both
//    init(
//        pageSize: CGSize,
//        horizontalScrollSetting: ScrollSetting,
//        verticalScrollSetting: ScrollSetting,
//        positionScrollViewDelegate: PositionScrollViewDelegate? = nil,_ childView: () -> (ChildView)) {
//        let scrollState = ScrollState(
//            pageSize: pageSize,
//            horizontalScroll: Scroll(scrollSetting: horizontalScrollSetting),
//            verticalScroll: Scroll(scrollSetting: verticalScrollSetting)
//        )
//        self.init(scrollState: scrollState, childView)
//    }
//
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
            ).mask(
                Rectangle().frame(width: self.scrollState.pageSize.width, height: scrollState.pageSize.height)
            )
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

//struct PositionScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        let pageSize = CGSize(width: 200, height: 200)
//        //        let scrollState = ScrollState(
//        //            pageSize: pageSize,
//        //            verticalScroll: Scroll(pageCount: 6, pageSize: pageSize.height, unitCountInPage: 1,
//        //                                     afterMoveType: .smooth)
//        //        )
//        return PositionScrollView(
//            pageSize: pageSize,
//            horizontalScrollSetting: ScrollSetting(pageCount: 6, pageSize: 200)
//        ) {
//            HStack(spacing: 0) {
//                ForEach(0...5, id: \.self){ _ in
//                    VStack(spacing: 0) {
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("0")
//                        }.border(Color.red)
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("1")
//                        }
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("2")
//                        }
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("3")
//                        }
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("4")
//                        }
//                        ZStack {
//                            Image("image").resizable().frame(width: 200, height: 200)
//                            Text("5")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

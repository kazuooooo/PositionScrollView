//
//  DimentionalScrollExample.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/09/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import SwiftUI

public struct DimentionalScrollExample: View, PositionScrollViewDelegate {
    /// Page size of Scroll
    var pageSize = CGSize(width: 200, height: 300)
    
    // Create PositionScrollViewModel
    // (Need to create in parent view to bind the state between this view and PositionScrollView)
    @ObservedObject var psViewModel = PositionScrollViewModel(
        pageSize: CGSize(width: 200, height: 300),
        horizontalScroll: Scroll(
            scrollSetting: ScrollSetting(pageCount: 5, afterMoveType: .fitToNearestUnit),
            pageLength: 200
        ),
        verticalScroll: Scroll(
            scrollSetting: ScrollSetting(pageCount: 5, afterMoveType: .fitToNearestUnit),
            pageLength: 300
        )
    )
    
    @State var hogePage: Int = 0

    public var body: some View {
        return VStack {
            PositionScrollView(
                viewModel: self.psViewModel,
                delegate: self
            ) {
                HStack(spacing: 0) {
                    ForEach(0...4, id: \.self){ hi in
                        VStack(spacing: 0) {
                            ForEach(0...4, id: \.self){ vi in
                                ZStack {
                                    Rectangle()
                                        .fill(BLUES[vi])
                                        .border(Color.white)
                                        .frame(
                                            width: self.pageSize.width, height: self.pageSize.height
                                    )
                                    Text("Page\(hi)-\(vi)")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 24, weight: .heavy, design: .default))
                                }
                            }
                            
                        }
                    }
                }
            }
            VStack {
                Text("verticalPage: \(self.psViewModel.horizontalScroll?.page ?? 0)")
                Text("verticalPosition: \(self.psViewModel.horizontalScroll?.position ?? 0)")
                Text("verticalPage: \(self.psViewModel.verticalScroll?.page ?? 0)")
                Text("verticalPosition: \(self.psViewModel.verticalScroll?.position ?? 0)")
                }
            .padding()
            .background(Color.white.opacity(0.7))
        }
    }
    
    struct SampleView_Previews: PreviewProvider {
        static var previews: some View {
            return MinimalHorizontalExample()
        }
    }
    
    // Delegate methods of PositionScrollView
    public func onScrollStart() {
        print("onScrollStart")
    }
    public func onChangePage(page: Int) {
        print("onChangePage to page: \(page)")
    }
    
    public func onChangePosition(position: CGFloat) {
        print("position: \(position)")
    }
    
    public func onScrollEnd() {
        print("onScrollEnd")
    }
}

struct DimentionalScrollExample_Previews: PreviewProvider {
    static var previews: some View {
        DimentionalScrollExample()
    }
}

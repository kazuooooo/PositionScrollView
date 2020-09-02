//
//  Sample.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation

import SwiftUI

/// Extended ScrollView which can controll position
public struct MinimalExample: View, PositionScrollViewDelegate {
    /// Page size of Scroll
    var pageSize = CGSize(width: 200, height: 300)
//    @State var position: CGFloat = 0
//    @State var page = 0

    public var body: some View {
        // 1. Define ScrollSetting
        let scrollSetting = ScrollSetting(
            pageCount: 6,
            afterMoveType: .fitToNearestUnit
        )
    
        return VStack {
            PositionScrollView(
                pageSize: pageSize,
                horizontalScrollSetting: scrollSetting,
                delegate: self
            ) {
                HStack(spacing: 0) {
                    ForEach(0...5, id: \.self){ i in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .border(Color.black)
                                .frame(
                                    width: self.pageSize.width, height: self.pageSize.height
                            )
                            Text("Page\(i)")
                        }
                    }
                    
                }
            }
//            Text("page: \(page)")
//            Text("position: \(position)")
        }
    }
    
    struct SampleView_Previews: PreviewProvider {
        static var previews: some View {
            return MinimalExample()
        }
    }
    
    // Delegate methods of PositionScrollView
    public func onScrollStart() {
        print("onScrollStart")
    }
    public func onScrollEnd() {
        print("onScrollEnd")
    }
    
    public func onChangePage(page: Int) {
        print("onChangePage to page: \(page)")
//        self.page = page
    }
    
    public func onChangePosition(position: CGFloat) {
        print("position: \(position)")
//        self.position = position
    }
}

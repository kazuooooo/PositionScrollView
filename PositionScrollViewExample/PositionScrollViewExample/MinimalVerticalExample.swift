//
//  MinimalVerticalExample.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/09/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import SwiftUI

import Foundation
import SwiftUI

/// Extended ScrollView which can controll position
public struct MinimalVerticalExample: View, PositionScrollViewDelegate {
    /// Page size of Scroll
    var pageSize = CGSize(width: 200, height: 300)
    
    // Create PositionScrollViewModel
    // (Need to create in parent view to bind the state between this view and PositionScrollView)
    @ObservedObject var psViewModel = PositionScrollViewModel(
        pageSize: CGSize(width: 200, height: 300),
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
                VStack(spacing: 0) {
                    ForEach(0...4, id: \.self){ i in
                        ZStack {
                            Rectangle()
                                .fill(BLUES[i])
                                .border(Color.white)
                                .frame(
                                    width: self.pageSize.width, height: self.pageSize.height
                            )
                            Text("Page\(i)")
                            .foregroundColor(Color.white)
                            .font(.system(size: 24, weight: .heavy, design: .default))
                        }
                    }
                    
                }
            }
            Text("page: \(self.psViewModel.verticalScroll?.page ?? 0)")
            Text("position: \(self.psViewModel.verticalScroll?.position ?? 0)")
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


struct MinimalVerticalExample_Previews: PreviewProvider {
    static var previews: some View {
        MinimalVerticalExample()
    }
}

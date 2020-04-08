//
//  Sample.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation

import SwiftUI

/// ScrollState ViewModel
//public class PositionInfo: ObservableObject {
//    @Published var position: CGFloat = 0
//    @Published var page: Int = 0
//    @Published var unit: Int = 0
//    @Published var positionInUnit: CGFloat = 0
//}

/// Extended ScrollView which can controll position
public struct SampleView: View {
    @State var position: CGFloat = 0
    
    var pageSize = CGSize(width: 200, height: 200)
    var colors = Color.sGradation()

    public var body: some View {
        VStack {
            PositionScrollView(
                pageSize: pageSize,
                horizontalScrollSetting: ScrollSetting(pageCount: 6, pageSize: 200, afterMoveType: .unit, positionScrollDelegate: self)
            ) {
                HStack(spacing: 0) {
                    ForEach(0...5, id: \.self){ i in
                        ZStack {
                            Rectangle()
                                .fill(self.colors[i])
                                .frame(
                                    width: self.pageSize.width, height: self.pageSize.height
                            )
                            Text("page\(i)")
                        }
                    }
                    
                }
            }
            VStack {
                Text("position: \(self.position)")
//                Text("page: \(positionInfo.page)")
//                Text("unit: \(positionInfo.unit)")
//                Text("positionInUnit: \(positionInfo.positionInUnit)")
            }
        }
    }
    
    struct SampleView_Previews: PreviewProvider {
        static var previews: some View {
            return SampleView()
        }
    }
}

extension SampleView: PositionScrollViewDelegate {
    func onChangePage(page: Int) {
//        self.positionInfo.page = page
    }
    
    func onChangeUnit(unit: Int) {
//        self.positionInfo.unit = unit
    }
    
    func onChangePositionInUnit(positionInUnit: CGFloat) {
//        self.positionInfo.positionInUnit = positionInUnit
    }
    
    func onChangePosition(position: CGFloat) {
        self.position = position
    }
}

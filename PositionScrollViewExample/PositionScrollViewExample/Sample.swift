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
public struct SampleView: View {
    public var body: some View {
               let pageSize = CGSize(width: 200, height: 200)
        //        let scrollState = ScrollState(
        //            pageSize: pageSize,
        //            verticalScroll: Scroll(pageCount: 6, pageSize: pageSize.height, unitCountInPage: 1,
        //                                     afterMoveType: .smooth)
        //        )
                return PositionScrollView(
                    pageSize: pageSize,
                    horizontalScrollSetting: ScrollSetting(pageCount: 6, pageSize: 200)
                ) {
                    HStack(spacing: 0) {
                        ForEach(0...5, id: \.self){ _ in
                            VStack(spacing: 0) {
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("0")
                            }
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("1")
                            }
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("2")
                            }
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("3")
                            }
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("4")
                            }
                            ZStack {
                                Image("image").resizable().frame(width: 200, height: 200)
                                Text("5")
                            }
                            }
                        }
                    }
                }
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        return SampleView()
    }
}

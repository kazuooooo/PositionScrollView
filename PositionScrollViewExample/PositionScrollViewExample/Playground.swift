//
//  Playground.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/08.
//  Copyright © 2020 松本和也. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var score = 0
}
struct Playground: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Playground_Previews: PreviewProvider {
    var settings = UserSettings()

    static var previews: some View {
        Playground()
    }
}

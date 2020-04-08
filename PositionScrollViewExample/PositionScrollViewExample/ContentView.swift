//
//  ContentView.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                // A button that writes to the environment settings
                Button(action: {
                    self.settings.score += 1
                }) {
                    Text("Increase Score")
                    Text("\(self.settings.score)")
                }

                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        // A text view that reads from the environment settings
        Text("Score: \(settings.score)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var settings = UserSettings()
        return ContentView().environmentObject(settings)
    }
}

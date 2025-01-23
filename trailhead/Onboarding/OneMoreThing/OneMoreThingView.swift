//
//  OneMoreThingView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//

import SwiftUI

struct OneMoreThingView: View {
    let onStartOver: () -> Void
    var body: some View {
        Text("Hello from one more thing!")
        VStack {
            Button("Start Over")
            {
                self.onStartOver()
            }
        }
    }
}

#Preview {
    OneMoreThingView{
        print("start over")
    }
}

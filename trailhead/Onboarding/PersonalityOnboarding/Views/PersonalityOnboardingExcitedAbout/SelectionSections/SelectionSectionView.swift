//
//  SelectionSectionView.swift
//  trailhead
//
//  Created by Robin Götz on 1/17/25.
//
import SwiftUI

struct SectionDisclosureStyle: DisclosureGroupStyle {
    let iconName: String
    
    init(iconName: String) {
        self.iconName = iconName
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                        .foregroundStyle(.foreground)
                        .padding(.trailing, 5)
                    configuration.label
                        .font(.title2)
                        .bold()
                    Spacer()
                    Image(systemName: "chevron.down")
                                         .rotationEffect(.degrees(configuration.isExpanded ? 0 : -90))
                     }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            configuration.content
                          .frame(maxHeight: configuration.isExpanded ? nil : 0)
                          .opacity(configuration.isExpanded ? 1 : 0)
                          .clipped()
                          .padding(-15)
        }
    }
}

struct SelectionSectionView<Content: View>: View {
    @State private var isExpanded: Bool = true
    let title: String
    let iconName: String
    let content: () -> Content

    init(title: String, iconName: String, content: @escaping () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content
    }
    
    var body: some View {
        DisclosureGroup(self.title, isExpanded: $isExpanded) {
            self.content()
        }
        .disclosureGroupStyle(SectionDisclosureStyle(iconName: self.iconName))
    }
}


#Preview {
    SelectionSectionView(title: "Sport", iconName: "basketball.fill") {
        Text("yooo")
               .frame(minHeight: 200)
    }
}

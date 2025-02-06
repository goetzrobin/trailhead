import SwiftUI

struct FramePreference: PreferenceKey {
    static var defaultValue: [Namespace.ID: CGRect] = [:]

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

enum StickyRects: EnvironmentKey {
    static var defaultValue: [Namespace.ID: CGRect]? = nil
}

extension EnvironmentValues {
    var stickyRects: StickyRects.Value {
        get { self[StickyRects.self] }
        set { self[StickyRects.self] = newValue }
    }
}

struct Sticky: ViewModifier {
    @Environment(\.stickyRects) var stickyRects
    @State var frame: CGRect = .zero
    @Namespace private var id

    var isSticking: Bool {
        frame.minY < 0
    }

    var offset: CGFloat {
        guard isSticking else { return 0 }
        guard let stickyRects else {
            print("Warning: Using .sticky() without .useStickyHeaders()")
            return 0
        }
        var o = -frame.minY
        if let other = stickyRects.first(where: { (key, value) in
            key != id && value.minY > frame.minY && value.minY < frame.height

        }) {
            o -= frame.height - other.value.minY
        }
        return o
    }

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .zIndex(isSticking ? .infinity : 0)
            .overlay(
                GeometryReader { proxy in
                    let f = proxy.frame(in: .named("container"))
                    Color.clear
                        .onAppear { frame = f }
                        .onChange(of: f) { _, newValue in frame = newValue }
                        .preference(
                            key: FramePreference.self, value: [id: frame])
                })
    }
}

extension View {
    func sticky() -> some View {
        modifier(Sticky())
    }
}

struct UseStickyHeaders: ViewModifier {
    @State private var frames: StickyRects.Value = [:]

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(
                FramePreference.self,
                perform: {
                    frames = $0
                }
            )
            .environment(\.stickyRects, frames)
            .coordinateSpace(name: "container")
    }
}

extension View {
    func useStickyHeaders() -> some View {
        modifier(UseStickyHeaders())
    }
}

struct PreviewStickyView: View {
    @State var scrollOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            contents
              
        }
        .coordinateSpace(name: "OutsideScrollView")
        .useStickyHeaders()
        .overlay {
            HStack {
                Text(verbatim: "\(scrollOffset)")
            }
            .foregroundColor(.white)
            .padding(2)
            .background(.black)
        }
    }

    @ViewBuilder var contents: some View {
        VStack(spacing: 0) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .padding()
                    .frame(height: 100)
                    .scaleEffect(max(0, (100 + scrollOffset) / 100))
                    .measureTop(in: .named("OutsideScrollView")) { top in
                        scrollOffset = top
                    }
                    .background(Color.green)
                Text("Hello, World!")
                    .font(.title)
            .padding()
            .background(.ultraThinMaterial)
            .sticky()
            LazyVStack(spacing: 0) {
                ForEach(0..<20, id: \.self) {
                    Text("Item \($0)")
                        .frame(height: 200)
                        .background(.blue.opacity(0.1))
                        .border(.gray, width: 0.5)
                }
            }
        }
    }
}

#Preview {
    PreviewStickyView()
}

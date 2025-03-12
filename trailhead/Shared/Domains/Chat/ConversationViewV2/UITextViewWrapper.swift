//
//  UITextViewWrapper.swift
//  trailhead
//
//  Created by Robin Götz on 3/10/25.
//
import SwiftUI
import UIKit

// UIKit UITextView wrapper for SwiftUI
struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    
    var minHeight: CGFloat
    var maxHeight: CGFloat
    var placeholder: String = "Share with Sam..."
    let placeholderTag = 100
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView
            .setContentCompressionResistancePriority(
                .defaultLow,
                for: .horizontal
            )
        textView.textContainerInset = UIEdgeInsets(
            top: 8,
            left: 4,
            bottom: 8,
            right: 4
        )
        textView.text = ""
        
        // Setup placeholder
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font =
            .systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(
            x: 7,
            y: (textView.font?.pointSize)! / 2
        )
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        placeholderLabel.tag = placeholderTag // We'll use this tag to find the label later
        
        textView.addSubview(placeholderLabel)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            // Find the placeholder label using its tag
            let placeholderLabel = uiView.viewWithTag(placeholderTag) as? UILabel
            
            
            // Update text if it has changed
            uiView.text = self.text
            // Manually trigger height recalculation when text changes
            recalculateHeight(view: uiView)
            
            
            // Update placeholder visibility
            placeholderLabel?.isHidden = !uiView.text.isEmpty
            
            if uiView.window != nil, !context.coordinator.didSetupInitialHeight {
                recalculateHeight(view: uiView)
                context.coordinator.didSetupInitialHeight = true
            }
        }
    }
    
    func recalculateHeight(view: UITextView) {
        let sizeThatFits = view.sizeThatFits(
            CGSize(
                width: view.frame.size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        
        if sizeThatFits.height != calculatedHeight {
            DispatchQueue.main.async {
                calculatedHeight = min(
                    max(sizeThatFits.height, minHeight),
                    maxHeight
                )
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var calculatedHeight: CGFloat
        var parent: UITextViewWrapper
        var didSetupInitialHeight = false
        
        init(
            text: Binding<String>,
            height: Binding<CGFloat>,
            parent: UITextViewWrapper
        ) {
            self._text = text
            self._calculatedHeight = height
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
            
            // Update placeholder visibility
            let placeholderLabel = textView.viewWithTag(
                parent.placeholderTag
            ) as? UILabel
            placeholderLabel?.isHidden = !textView.text.isEmpty
            
            parent.recalculateHeight(view: textView)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Hide placeholder when editing begins
            let placeholderLabel = textView.viewWithTag(
                parent.placeholderTag
            ) as? UILabel
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Show placeholder if text is empty when editing ends
            let placeholderLabel = textView.viewWithTag(
                parent.placeholderTag
            ) as? UILabel
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}

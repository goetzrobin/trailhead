//
//  CheckInAnimationViewModel.swift
//  trailhead
//
//  Created by Robin Götz on 2/10/25.
//
import Observation
import SwiftUI

@Observable final class CheckInAnimationViewModel {
    var rotation = 0.0
    var scrollOffset: CGFloat = 0.0
    var isDragging = false
    var dragStartOffset: CGFloat = 0
    var shouldAnimate = true
    private let overAllRateOfChange = 2.0

    func handleScroll(offset: CGFloat) {
        scrollOffset = offset
    }

    // MARK: - Transition Calculations
    func smoothTransition(
        value: CGFloat, delay: CGFloat, rate: CGFloat,
        min minVal: CGFloat = 0, max maxVal: CGFloat = 1
    ) -> CGFloat {
        return self.shouldAnimate ? min(maxVal, max((value + delay + rate) / rate, minVal)) : 1
    }

    var textOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 30, rate: 12 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var textOffset: CGFloat {
        50
            * smoothTransition(
                value: scrollOffset, delay: 20, rate: 35 * overAllRateOfChange,
                min: 0, max: 1)
    }

    var circleScaleFactor: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 0, rate: 400 * overAllRateOfChange,
            min: 0.4, max: 1)
    }

    var circleOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 150, rate: 50 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var checkInButtonOpacity: CGFloat {
        smoothTransition(
            value: scrollOffset, delay: 200, rate: 20 * overAllRateOfChange,
            min: 0, max: 1)
    }

    var circlePadding: CGFloat {
        50
            * smoothTransition(
                value: scrollOffset, delay: 0, rate: 40 * overAllRateOfChange,
                min: 0, max: 1)
    }

    var circleWrapperScaleFactor: CGFloat {
        1.4
            * smoothTransition(
                value: scrollOffset, delay: 0, rate: 250 * overAllRateOfChange,
                min: 0.4, max: 1)
    }

}

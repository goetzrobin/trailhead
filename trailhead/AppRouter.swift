//
//  AppRouter.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//
import Observation
import SwiftUI

enum AppPath: Hashable {
//  NOT LOGGED IN: empty -> onBoarding
//  LOGGED IN: empty -> home
}

@Observable class AppRouter {
    var path: NavigationPath = NavigationPath()
}

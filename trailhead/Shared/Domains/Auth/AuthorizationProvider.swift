//
//  AuthorizationProvider.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//

protocol AuthorizationProvider {
    /// For example, return "Bearer <token>" or any other auth scheme you need.
    func authorizationHeader() -> String
}

//
//  Constants.swift
//  trailhead
//
//  Created by Robin Götz on 2/17/25.
//

import Foundation

final class env {
    public static let SUPABASE_URL: String = {
        guard
            let supabaseUrl = Bundle.main.infoDictionary!["SUPABASE_URL"]
                as? String
        else {
            preconditionFailure("SUPABASE_URL cannot be nil")
        }
        return supabaseUrl
    }()
    
    public static let SUPABASE_KEY: String = {
        guard
            let supabaseKey = Bundle.main.infoDictionary!["SUPABASE_KEY"]
                as? String
        else {
            preconditionFailure("SUPABASE_KEY cannot be nil")
        }
        return supabaseKey
    }()
    
    public static let API_ROOT_URL: String = {
        guard
            let apiRootURL =
                Bundle.main.infoDictionary!["API_ROOT_URL"] as? String
        else {
            preconditionFailure("API_ROOT_URL cannot be nil")
        }
        return apiRootURL
    }()
}

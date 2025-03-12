//
//  PromptOptionAndResponse.swift
//  trailhead
//
//  Created by Robin Götz on 1/29/25.
//
struct PromptOptionAndResponse {
    var option: PromptOption
    var response: String?
    
    var isEmpty: Bool {
         return response == nil || response!.isEmpty
     }
}

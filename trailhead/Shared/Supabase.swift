//
//  Supabase.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//
import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: env.SUPABASE_URL)!,
    supabaseKey: env.SUPABASE_KEY
)

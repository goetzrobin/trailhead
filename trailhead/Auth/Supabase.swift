//
//  Supabase.swift
//  trailhead
//
//  Created by Robin Götz on 12/11/24.
//
import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://sxtpdrbqkflduazyzuga.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4dHBkcmJxa2ZsZHVhenl6dWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxMDc4ODYsImV4cCI6MjAzNTY4Mzg4Nn0.xJmCk1BoDw0iMKBWeQs4mskXcD2oxLGsEal5vYmHPI4"
)

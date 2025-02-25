//
//  RequestStatus.swift
//  trailhead
//
//  Created by Robin Götz on 2/12/25.
//
enum ResponseStatus<T>: Equatable, Hashable {
    case idle
    case loading
    case success(T)
    case error(Error)
    
    var data: T? {
          switch self {
          case .success(let value):
              return value
          default:
              return nil
          }
      }
    
    static func == (lhs: ResponseStatus<T>, rhs: ResponseStatus<T>) -> Bool {
           switch (lhs, rhs) {
           case (.idle, .idle), (.loading, .loading):
               return true
           case (.success(_), .success(_)):
               return true
           case (.error(_), .error(_)):
               return true
           default:
               return false
           }
       }
    
    func hash(into hasher: inout Hasher) {
           switch self {
           case .idle:
               hasher.combine(0)
           case .loading:
               hasher.combine(1)
           case .success(_):
               hasher.combine(2)
           case .error(_):
               hasher.combine(3)
           }
       }
}

//
//  NetworkMonitor.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue (label: "Monitor")
    var isActive = false
    @Published var hasLostConnection = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                // Update the lost connection status
                self.hasLostConnection = !self.isActive
            }
        }
        monitor.start(queue: queue)
    }
}


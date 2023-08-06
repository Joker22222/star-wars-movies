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
    @Published var isActive = false
    @Published var isExpensive = false
    @Published var isConstrained = false
    @Published var connectionType = NWInterface.InterfaceType.other
    @Published var hasLostConnection = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
                
                // Update the lost connection status
                self.hasLostConnection = !self.isActive
            }
        }
        monitor.start(queue: queue)
    }
}


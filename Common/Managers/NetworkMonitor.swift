//
//  NetworkMonitor.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    var isConnected: Bool = false
    
    private var connectionType: ConnectionType = .unknown
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    enum ConnectionType {
        case wifi
        case cellular
        case internet
        case unknown
    }
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .internet
        } else {
            connectionType = .unknown
        }
    }
    
}

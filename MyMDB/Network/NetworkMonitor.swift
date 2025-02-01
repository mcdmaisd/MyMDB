//
//  NetworkMonitor.swift
//  MyMDB
//
//  Created by ilim on 2025-02-01.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: C.queueLabel)
    private var previousStatus: NWPath.Status = .satisfied
    
    var status: ((NWPath.Status) -> Void)?
    
    func startCheckingNetwork() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied && previousStatus == .unsatisfied {
                status?(path.status)
            } else if path.status == .unsatisfied && previousStatus == .satisfied {
                status?(path.status)
            }
            previousStatus = path.status
        }
    }
    
    func stopCheckingNetwork() {
        monitor.cancel()
    }
}

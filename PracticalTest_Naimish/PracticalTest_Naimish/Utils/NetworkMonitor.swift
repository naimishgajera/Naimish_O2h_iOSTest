//
//  NetworkMonitor.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 28/03/26.
//


import Network

class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool = false

    var connectionHandler: ((Bool) -> Void)?

    private init() {}

    func startMonitoring() {

        monitor.pathUpdateHandler = { path in

            let status = path.status == .satisfied

            DispatchQueue.main.async {
                self.isConnected = status
                self.connectionHandler?(status)
            }
        }

        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

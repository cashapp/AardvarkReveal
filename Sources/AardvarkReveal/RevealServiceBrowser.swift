//
//  Copyright 2020 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

protocol RevealService: AnyObject {

    var port: Int { get }

}

extension NetService: RevealService {}

// MARK: -

protocol RevealServiceBrowsing: AnyObject {

    var localService: RevealService? { get }

    func startSearching()

    func stopSearching()

}

// MARK: -

final class RevealServiceBrowser: NSObject, NetServiceBrowserDelegate, RevealServiceBrowsing {

    // MARK: - Life Cycle

    override init() {
        super.init()

        serviceBrowser.delegate = self
    }

    // MARK: - Internal Properties

    var localService: RevealService? {
        // When running on device, the host name will match the device's host name. When running in a simulator, the
        // host name will be "localhost.".
        let deviceHostName = ProcessInfo.processInfo.hostName.lowercased() + "."

        // Find the last service with a matching host name. If multiple services are published (e.g. the app was
        // backgrounded, then brought back to the foreground), only the last one will be active.
        return services.reversed().first {
            $0.hostName?.lowercased() == deviceHostName || $0.hostName == "localhost."
        }
    }

    // MARK: - Private Properties

    private let serviceBrowser: NetServiceBrowser = .init()

    private var services: [NetService] = []

    private var isSearching = false

    // MARK: - NetServiceBrowserDelegate

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.resolve(withTimeout: 10)
        services.append(service)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        services.removeAll { $0 == service }
    }

    // MARK: - Internal Methods

    func startSearching() {
        // The service browser won't find the service if we tell it to search multiple times, so make sure we only tell
        // it to start searching if it hasn't started yet or was previously stopped.
        guard !isSearching else {
            return
        }

        serviceBrowser.searchForServices(ofType: "_reveal._tcp.", inDomain: "local.")
        isSearching = true
    }

    func stopSearching() {
        serviceBrowser.stop()
        isSearching = false
    }

}

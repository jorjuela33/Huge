//
//  Server.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Foundation

struct Server {
    let host: String
    let isSecure: Bool
    let path: String

    static let production = Server(host: "data.fixer.io", isSecure: true)
    static let staging = Server(host: "data.fixer.io", isSecure: true)
    
    // MARK: Initializers
    
    // TODO: HOW we can get this dynamic?
    init(host: String, isSecure: Bool, path: String = "api") {
        self.host = host
        self.isSecure = isSecure
        self.path = path
    }
    
    // MARK: Instance methods
    
    func connectionURL() -> URL {
        let scheme = isSecure ? "https" : "http"
        guard let url = URL(string: "\(scheme)://\(host)") else {
            fatalError("If you want to send a request we should provide a valid url!")
        }
        
        return url.appendingPathComponent(path)        
    }
}

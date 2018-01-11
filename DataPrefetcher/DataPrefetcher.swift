//
//  DataPrefetcher.swift
//  SmoothTableView
//
//  Created by Li-Heng Hsu on 10/01/2018.
//  Copyright © 2018 Li-Heng Hsu. All rights reserved.
//

import UIKit

public class DataPrefetcher: NSObject {
    
    let requestForIndexPath: (IndexPath) -> URLRequest
    public lazy var session = URLSession(configuration: .default)
    
    public init(requestForIndexPath: @escaping (IndexPath) -> URLRequest) {
        self.requestForIndexPath = requestForIndexPath
    }
    
    public func request(_ url: URL, handler: @escaping (Data) -> Void) {
        request(URLRequest(url: url), handler: handler)
    }
    
    public func request(_ request: URLRequest, handler: @escaping (Data) -> Void) {
        let session = self.session
        if let response = session.configuration.urlCache?.cachedResponse(for: request) {
            DispatchQueue.global().async {
                handler(response.data)
            }
        } else {
            session.dataTask(with: request) { (data, response, _) in
                guard let data = data, let response = response else { return }
                session.configuration.urlCache?.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                handler(data)
            }.resume()
        }
    }
    
    public func cancel(_ requests: [URLRequest]) {
        session.getTasksWithCompletionHandler { (tasks, _, _) in
            for request in requests {
                tasks.filter { $0.originalRequest == request }.forEach { $0.cancel() }
            }
        }
    }
    
}

//
//  DataPrefetcher+UITableViewDataSourcePrefetching.swift
//  DataPrefetcher
//
//  Created by Li-Heng Hsu on 10/01/2018.
//  Copyright © 2018 Li-Heng Hsu. All rights reserved.
//

import UIKit

extension DataPrefetcher: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let session = self.session
        for indexPath in indexPaths {
            let request = requestForIndexPath(indexPath)
            if session.configuration.urlCache?.cachedResponse(for: request) == nil {
                session.dataTask(with: request).resume()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let requests = indexPaths.map { self.requestForIndexPath($0) }
        cancel(requests)
    }
    
}

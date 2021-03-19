//
//  URLInformationCache.swift
//  Ocarina
//
//  Created by Rens Verhoeven on 15/02/2017.
//  Copyright © 2017 awkward. All rights reserved.
//

import Foundation

/// The cache used by a OrcarinaManager to hold a cache of URLInformation
public class URLInformationCache {
	class Wrapped {
		let value: URLInformation
		init(value: URLInformation) {
			self.value = value
		}
		
	}
    
    /// The internal NSCache used to cache the URLInformation
    let cache = NSCache<NSURL, Wrapped>()
    
    public subscript(url: URL) -> URLInformation? {
        get {
			return self.cache.object(forKey: url as NSURL)?.value
        }
        set {
            guard let information = newValue else {
                self.cache.removeObject(forKey: url as NSURL)
                return
            }
            self.cache.setObject(Wrapped(value: information), forKey: url as NSURL)
        }
    }
    
    
    /// Clears all the URLInformation models from the cache
    public func clear() {
        self.cache.removeAllObjects()
    }
    
}

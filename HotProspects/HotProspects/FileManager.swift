//
//  FileManager.swift
//  Bucketlist
//
//  Created by Gorkem Turan on 12.01.2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

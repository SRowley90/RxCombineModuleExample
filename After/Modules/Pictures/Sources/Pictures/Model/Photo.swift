//
//  File.swift
//  
//
//  Created by Sam Rowley on 29/10/2021.
//

import Foundation

struct Photo: Decodable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}

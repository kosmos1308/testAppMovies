//
//  Movies.swift
//  testAppMovies
//
//  Created by pavel on 14.10.21.
//

import Foundation

struct Movies: Decodable {
    let total_results: Int
    let results: [PopularMovies]
}

struct PopularMovies: Decodable {
    let original_title: String
    let overview: String
    
    let poster_path: String
    let title: String
    
    let release_date: String
    let genre_ids: [Int]
}

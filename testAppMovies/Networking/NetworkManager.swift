//
//  NetworkManager.swift
//  testAppMovies
//
//  Created by pavel on 14.10.21.
//

import Foundation

class NetworkManager {
    
    func request(urlString: String, completion: @escaping (Result<Movies, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error", error)
                    return
                }
                guard let data = data else {return}
                do {
                    let movies = try JSONDecoder().decode(Movies.self, from: data)
                    completion(.success(movies))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}

//
//  MovieService.swift
//  TMDBLibrary
//  Created by Serhii Bets on 09.04.2022.
//  Copyright © 2022 All rights reserved.
//
import Foundation

// MovieService protocol funcs
protocol MovieService {
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie]
    func fetchMovie(id: Int) async throws -> Movie
    func searchMovie(query: String) async throws -> [Movie]
}

// MARK: - MoviesListEndpoints
enum MovieListEndpoint: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

// MARK: - MovieErrors
enum MovieError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError          : return "Failed to fetch data"
        case .invalidEndpoint   : return "Invalid endpoint"
        case .invalidResponse   : return "Invalid response"
        case .noData            : return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}


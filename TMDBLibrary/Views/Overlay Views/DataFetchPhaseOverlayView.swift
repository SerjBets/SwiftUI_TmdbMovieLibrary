//
//  DataFetchPhaseOverlayView.swift
//  TMDBLibrary
//  Created by Serhii Bets on 09.04.2022.
//  Copyright © 2022 All rights reserved.
//
import SwiftUI

protocol EmptyData {
    var isEmpty: Bool { get }
}

struct DataFetchPhaseOverlayView<V: EmptyData>: View {
    
    let phase: DataFetchPhase<V>
    let retryAction: () -> ()
    
    var body: some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success(let value) where value.isEmpty:
            EmptyPlaceholderView(text: "No data", image: Image(systemName: "film"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: retryAction)
        default:
            EmptyView()
        }
    }
}

extension Array: EmptyData {}
extension Optional: EmptyData {
    var isEmpty: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}

struct DataFetchPhaseOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataFetchPhaseOverlayView(phase: .success([])) {
                print("Retry")
            }
            DataFetchPhaseOverlayView<[Movie]>(phase: .empty) {
                print("Retry")
            }
            DataFetchPhaseOverlayView<Movie?>(phase: .failure(MovieError.invalidResponse)) {
                print("Retry")
            }
        }
        
        
    }
}

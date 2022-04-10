//
//  ActivityIndicatorView.swift
//  TMDBLibrary
//  Created by Serhii Bets on 09.04.2022.
//  Copyright © 2022 All rights reserved.
//
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
}

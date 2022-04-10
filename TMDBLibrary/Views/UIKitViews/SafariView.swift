//
//  SafariView.swift
//  TMDBLibrary
//  Created by Serhii Bets on 09.04.2022.
//  Copyright © 2022 All rights reserved.
//
import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: self.url)
        return safariVC
    }
}

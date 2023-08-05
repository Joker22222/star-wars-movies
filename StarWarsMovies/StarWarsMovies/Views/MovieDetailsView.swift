//
//  MovieDetailsView.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 05/08/2023.
//

import SwiftUI
import AVKit
import WebKit

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    @State private var isShowingTrailerPopup = false
    
    init(viewModel: MovieDetailsViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    var body: some View {
        if let movieDetails = viewModel.movieDetails {
            
            
            VStack {
                VStack(alignment: .center, spacing: 16) {
                    
                    Text(movieDetails.short.name)
                        .font(.title)
                        .bold()
                        .padding()
                    Text(movieDetails.short.movieDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    VStack {
                        Button("Trailer") {
                            isShowingTrailerPopup = true
                        }
                    }
                }.background(.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .padding(.top, 110)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
                
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    AsyncImage(url: URL(string: viewModel.movieDetails?.short.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                )
                .ignoresSafeArea()
                .sheet(isPresented: $isShowingTrailerPopup) {
                                WebView(url: URL(string: movieDetails.short.trailer.embedUrl)!)
                            }
        } else {
            ProgressView()
        }
    }
}


struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(viewModel: MovieDetailsViewModel(imdbId: "", movieDetails: MovieDetails(short: ShortResponse(name: "Star Wars", image: "https://m.media-amazon.com/images/M/MV5BMjEwMzMxODIzOV5BMl5BanBnXkFtZTgwNzg3OTAzMDI@._V1_.jpg", movieDescription: "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire&apos;s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth ...", trailer: Trailer(embedUrl: "https://bit.ly/swswift")), imdbId: "")))
    }
}


struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: URL(string: "https://imdb-video.media-imdb.com/vi1317709849/1434659607842-pgv4ql-1616202535791.mp4?Expires=1691252906&Signature=Rh1CVB9z3f9pwx5dwR8n1hva3MHQKasgWOrSzVI~z2YdXzIVOknUppqwh36rRiYii5vSClKmwj5pKSRQICrVIxhzb5oFf~6MIBZMnAlTdROgZYpdFwenIlzSL3X2ptguKAUsiBefTTbdqJOVDALybn327SWL-Oe80AaLbMvhCmX0S2-HBv48qq-C3I4xGE~slswD1QwW3eBm8qE5hJ5Q479agWMi1jrvGkHsBIMjeUCfSULa7Y7VKQURpuyiFS09YB4YkeAIAow63iIXWninD7tNzLm9acCZLslrZqZhsTFoqG4-PyNrPlLTGpCCCYM5MfR~6r0jYMk8aGafY5UoeQ__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA")!)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        // If you need to handle any navigation events or other delegate methods,
        // you can add them here.
    }
}

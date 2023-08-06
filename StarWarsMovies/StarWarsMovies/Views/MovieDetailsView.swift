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
                Spacer()
                VStack(spacing: 15) {
                    Text(movieDetails.short.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    Text(movieDetails.short.movieDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.init(top: 0, leading: 30, bottom: 20, trailing: 30))
                    VStack {
                        Button(action: {
                            isShowingTrailerPopup = true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .clipShape(Circle())
                        }
                        Text("Play Trailer")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 40)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }.frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .ignoresSafeArea()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    AsyncImage(url: URL(string: viewModel.movieDetails?.short.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                ).ignoresSafeArea()
                .sheet(isPresented: $isShowingTrailerPopup) {
                    ZStack {
                        ProgressView()
                        WebView(url: URL(string: movieDetails.short.trailer.embedUrl)!)
                            .frame(height: 220)
                    }
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
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = [.video]
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.scrollView.isScrollEnabled = false
        uiView.isHidden = true
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // Pass the WebView instance to the coordinator
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let webView: WebView // Store the WebView instance
        
        init(_ webView: WebView) {
            self.webView = webView
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.getElementById('imdbHeader').remove();")
            webView.evaluateJavaScript("""
                var divVideoActionBar = document.querySelector('[data-testid="VideoActionBar"]');
                            if (divVideoActionBar) {
                                divVideoActionBar.remove();
                }
            """)
            webView.isHidden = false
        }
    }
}

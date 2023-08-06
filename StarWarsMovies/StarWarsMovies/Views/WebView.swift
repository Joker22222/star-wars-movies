//
//  WebView.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import SwiftUI
import WebKit

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

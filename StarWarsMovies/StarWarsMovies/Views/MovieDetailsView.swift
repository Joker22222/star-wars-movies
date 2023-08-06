//
//  MovieDetailsView.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 05/08/2023.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @ObservedObject var viewModel: MovieDetailsViewModel
        @State private var isShowingTrailerPopup = false
        @State private var offset: CGFloat = 0
        
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
                                Image(systemName: viewModel.circleShapeIdentifier)
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(viewModel.primaryColorIdentifier))
                                    .clipShape(Circle())
                            }
                            Text(viewModel.playTrailerButtonText)
                                .font(.title)
                                .bold()
                                .padding(.bottom, 40)
                                .foregroundColor(Color(viewModel.primaryColorIdentifier))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .ignoresSafeArea()
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged { value in
                        withAnimation {
                            offset = max(value.translation.height, -150) // 150 is the threshold to start animating
                        }
                    }.onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.height < 50 { // 50 is the threshold to reset the view
                                offset = 0
                            } else {
                                offset = 300
                            }
                        }
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        MovieDetailsView(viewModel: MovieDetailsViewModel(imdbId: "", movieDetails: MockData.mockMovieDetails))
    }
}

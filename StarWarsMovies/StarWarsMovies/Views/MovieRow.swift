//
//  MovieRow.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import SwiftUI

struct MovieRow: View {
    @StateObject private var viewModel: MovieRowViewModel
    
    init(viewModel: MovieRowViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(imdbId: viewModel.imdbId, movieDetails: nil))) {
            HStack(spacing: 10) {
                // Poster Image (assuming you have a method to load the image from URL)
                AsyncImage(url: URL(string: viewModel.movie.imgPoster)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 90) // Adjust the size of the poster thumbnail
                        .cornerRadius(10)
                } placeholder: {
                    ZStack {
                        Color.gray // Placeholder while loading the image
                            .frame(width: 60, height: 90)
                            .cornerRadius(10)
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.movie.title)
                        .font(.headline)
                        .foregroundColor(Color(viewModel.primaryColorIdentifier))
                    Text(viewModel.movie.actors)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieRow(viewModel: MovieRowViewModel(movie: MockData.mockMovie))
    }
}

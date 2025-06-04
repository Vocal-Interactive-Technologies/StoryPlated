import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .navigationTitle("StoryPlated")
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "")
            }
        }
        .onAppear {
            viewModel.loadRecipes()
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .font(.headline)
            
            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text(recipe.character.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(recipe.difficulty.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var difficultyColor: Color {
        switch recipe.difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
} 
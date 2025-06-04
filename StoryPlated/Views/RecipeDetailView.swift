import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var showingCookingSession = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Character Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Guide")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(recipe.character.name.prefix(1)))
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(recipe.character.name)
                                .font(.title3)
                                .bold()
                            
                            Text(recipe.character.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Ingredients
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.headline)
                    
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        HStack {
                            Text("•")
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.amount)\(ingredient.unit ?? "")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Steps Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Steps")
                        .font(.headline)
                    
                    ForEach(recipe.steps.prefix(2)) { step in
                        HStack(alignment: .top) {
                            Text("\(step.order).")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(step.instruction)
                                .font(.subheadline)
                        }
                    }
                    
                    if recipe.steps.count > 2 {
                        Text("+ \(recipe.steps.count - 2) more steps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Start Cooking Button
                Button(action: {
                    showingCookingSession = true
                }) {
                    Text("Start Cooking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(recipe.isUnlocked ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!recipe.isUnlocked)
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingCookingSession) {
            CookingSessionView(recipe: recipe)
        }
    }
} 
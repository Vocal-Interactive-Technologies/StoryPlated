import Foundation
import Combine

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let dataService: MockDataService
    
    init(dataService: MockDataService = .shared) {
        self.dataService = dataService
    }
    
    func loadRecipes() {
        isLoading = true
        error = nil
        
        Task {
            do {
                recipes = try await dataService.getRecipes()
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
} 
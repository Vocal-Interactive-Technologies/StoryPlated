import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let character: RecipeCharacter
    let difficulty: RecipeDifficulty
    let ingredients: [Ingredient]
    let steps: [RecipeStep]
    let imageURL: URL?
    let estimatedTime: TimeInterval
    var isUnlocked: Bool
    
    enum RecipeDifficulty: String, Codable {
        case easy
        case medium
        case hard
    }
}

struct RecipeCharacter: Codable {
    let name: String
    let description: String
    let voiceId: String // For TTS service
    let personality: String
}

struct Ingredient: Codable {
    let name: String
    let amount: String
    let unit: String?
}

struct RecipeStep: Identifiable, Codable {
    let id: String
    let order: Int
    let instruction: String
    let duration: TimeInterval?
    let imageURL: URL?
} 
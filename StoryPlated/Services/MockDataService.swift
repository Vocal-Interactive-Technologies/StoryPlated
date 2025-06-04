import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    func getRecipes() async throws -> [Recipe] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Recipe(
                id: "1",
                title: "Hobbit's Second Breakfast",
                description: "A hearty breakfast fit for a hobbit, featuring mushrooms, bacon, and eggs.",
                character: RecipeCharacter(
                    name: "Samwise Gamgee",
                    description: "A loyal hobbit with a passion for cooking",
                    voiceId: "sam_voice",
                    personality: "Friendly and encouraging, with a love for good food and simple pleasures"
                ),
                difficulty: .easy,
                ingredients: [
                    Ingredient(name: "Mushrooms", amount: "200", unit: "g"),
                    Ingredient(name: "Bacon", amount: "4", unit: "slices"),
                    Ingredient(name: "Eggs", amount: "4", unit: nil),
                    Ingredient(name: "Butter", amount: "2", unit: "tbsp")
                ],
                steps: [
                    RecipeStep(id: "1-1", order: 1, instruction: "Slice the mushrooms into thick pieces.", duration: 300, imageURL: nil),
                    RecipeStep(id: "1-2", order: 2, instruction: "Fry the bacon until crispy.", duration: 600, imageURL: nil),
                    RecipeStep(id: "1-3", order: 3, instruction: "Cook the mushrooms in the bacon fat.", duration: 300, imageURL: nil),
                    RecipeStep(id: "1-4", order: 4, instruction: "Fry the eggs to your liking.", duration: 300, imageURL: nil)
                ],
                imageURL: nil,
                estimatedTime: 1800,
                isUnlocked: true
            ),
            Recipe(
                id: "2",
                title: "Wizard's Fire Whiskey",
                description: "A magical cocktail that sparkles and fizzes like magic.",
                character: RecipeCharacter(
                    name: "Gandalf",
                    description: "A wise wizard with a taste for the finer things",
                    voiceId: "gandalf_voice",
                    personality: "Mysterious and wise, with a hint of mischief"
                ),
                difficulty: .medium,
                ingredients: [
                    Ingredient(name: "Whiskey", amount: "60", unit: "ml"),
                    Ingredient(name: "Blue Curacao", amount: "30", unit: "ml"),
                    Ingredient(name: "Lemon Juice", amount: "15", unit: "ml"),
                    Ingredient(name: "Dry Ice", amount: "1", unit: "cube")
                ],
                steps: [
                    RecipeStep(id: "2-1", order: 1, instruction: "Combine whiskey, blue curacao, and lemon juice in a shaker.", duration: 120, imageURL: nil),
                    RecipeStep(id: "2-2", order: 2, instruction: "Shake vigorously for 30 seconds.", duration: 30, imageURL: nil),
                    RecipeStep(id: "2-3", order: 3, instruction: "Strain into a chilled glass.", duration: 60, imageURL: nil),
                    RecipeStep(id: "2-4", order: 4, instruction: "Add dry ice and watch the magic happen!", duration: 30, imageURL: nil)
                ],
                imageURL: nil,
                estimatedTime: 300,
                isUnlocked: false
            ),
            Recipe(
                id: "3",
                title: "Elven Lembas Bread",
                description: "The waybread of the elves, sustaining and delicious.",
                character: RecipeCharacter(
                    name: "Galadriel",
                    description: "An elven queen with ancient wisdom",
                    voiceId: "galadriel_voice",
                    personality: "Elegant and ethereal, with a deep connection to nature"
                ),
                difficulty: .hard,
                ingredients: [
                    Ingredient(name: "Flour", amount: "500", unit: "g"),
                    Ingredient(name: "Honey", amount: "200", unit: "g"),
                    Ingredient(name: "Butter", amount: "100", unit: "g"),
                    Ingredient(name: "Milk", amount: "250", unit: "ml")
                ],
                steps: [
                    RecipeStep(id: "3-1", order: 1, instruction: "Mix flour and butter until crumbly.", duration: 600, imageURL: nil),
                    RecipeStep(id: "3-2", order: 2, instruction: "Add honey and milk, knead until smooth.", duration: 900, imageURL: nil),
                    RecipeStep(id: "3-3", order: 3, instruction: "Shape into thin cakes.", duration: 300, imageURL: nil),
                    RecipeStep(id: "3-4", order: 4, instruction: "Bake until golden brown.", duration: 1800, imageURL: nil)
                ],
                imageURL: nil,
                estimatedTime: 3600,
                isUnlocked: false
            )
        ]
    }
} 
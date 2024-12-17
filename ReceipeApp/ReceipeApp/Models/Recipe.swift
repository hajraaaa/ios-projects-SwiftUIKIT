import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable, Equatable {
    let recipes: [Recipe]
    let total, skip, limit: Int
}

// MARK: - Recipe
class Recipe: Identifiable, Equatable, Codable {
    var id: Int
    var name: String
    var ingredients: [String]
    var instructions: [String]
    var prepTimeMinutes: Int
    var cookTimeMinutes: Int
    var servings: Int
    var difficulty: Difficulty
    var cuisine: String
    var caloriesPerServing: Int
    var tags: [String]
    var userID: Int
    var image: String
    var rating: Double
    var reviewCount: Int
    var mealType: [String]
    
    // MARK: - Custom Initializer
    init(
        id: Int,
        name: String,
        ingredients: [String],
        instructions: [String],
        prepTimeMinutes: Int,
        cookTimeMinutes: Int,
        servings: Int,
        difficulty: Difficulty,
        cuisine: String,
        caloriesPerServing: Int,
        tags: [String],
        userID: Int,
        image: String,
        rating: Double,
        reviewCount: Int,
        mealType: [String]
    ) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.servings = servings
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.caloriesPerServing = caloriesPerServing
        self.tags = tags
        self.userID = userID
        self.image = image
        self.rating = rating
        self.reviewCount = reviewCount
        self.mealType = mealType
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Codable Conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        ingredients = try container.decode([String].self, forKey: .ingredients)
        instructions = try container.decode([String].self, forKey: .instructions)
        prepTimeMinutes = try container.decode(Int.self, forKey: .prepTimeMinutes)
        cookTimeMinutes = try container.decode(Int.self, forKey: .cookTimeMinutes)
        servings = try container.decode(Int.self, forKey: .servings)
        difficulty = try container.decode(Difficulty.self, forKey: .difficulty)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        caloriesPerServing = try container.decode(Int.self, forKey: .caloriesPerServing)
        tags = try container.decode([String].self, forKey: .tags)
        userID = try container.decode(Int.self, forKey: .userID)
        image = try container.decode(String.self, forKey: .image)
        rating = try container.decode(Double.self, forKey: .rating)
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        mealType = try container.decode([String].self, forKey: .mealType)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(prepTimeMinutes, forKey: .prepTimeMinutes)
        try container.encode(cookTimeMinutes, forKey: .cookTimeMinutes)
        try container.encode(servings, forKey: .servings)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(caloriesPerServing, forKey: .caloriesPerServing)
        try container.encode(tags, forKey: .tags)
        try container.encode(userID, forKey: .userID)
        try container.encode(image, forKey: .image)
        try container.encode(rating, forKey: .rating)
        try container.encode(reviewCount, forKey: .reviewCount)
        try container.encode(mealType, forKey: .mealType)
    }
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id, name, ingredients, instructions, prepTimeMinutes, cookTimeMinutes, servings, difficulty, cuisine, caloriesPerServing, tags
        case userID = "userId"
        case image, rating, reviewCount, mealType
    }
}

// MARK: - Enum for Difficulty
enum Difficulty: String, Codable, Equatable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

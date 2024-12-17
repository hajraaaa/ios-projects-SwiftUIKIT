import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var caloriesPerServing: Int32
    @NSManaged public var cookTimeMinutes: Int32
    @NSManaged public var cuisine: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var instructions: String?
    @NSManaged public var mealType: String?
    @NSManaged public var name: String?
    @NSManaged public var prepTimeMinutes: Int32
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int32
    @NSManaged public var servings: Int32
    @NSManaged public var tags: String?
    @NSManaged public var userID: Int64
    
    
        func toRecipe() -> Recipe {
            return Recipe(
                id: Int(id),
                name: name ?? "",
                ingredients: ingredients?.components(separatedBy: ",") ?? [],
                instructions: instructions?.components(separatedBy: ",") ?? [],
                prepTimeMinutes: Int(prepTimeMinutes),
                cookTimeMinutes: Int(cookTimeMinutes),
                servings: Int(servings),
                difficulty: Difficulty(rawValue: difficulty ?? "") ?? .easy,
                cuisine: cuisine ?? "",
                caloriesPerServing: Int(caloriesPerServing),
                tags: tags?.components(separatedBy: ",") ?? [],
                userID: Int(userID),
                image: image ?? "",
                rating: rating,
                reviewCount: Int(reviewCount),
                mealType: mealType?.components(separatedBy: ",") ?? []
            )
        }
}


import UIKit
import Alamofire
import CoreData

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryItem: UICollectionView!
    @IBOutlet weak var receipeCard: UITableView!
    
    private var recipes: [Recipe] = []
    private var uniqueTags: [String] = ["All"]
    private var filteredRecipes: [Recipe] = []
    private var selectedTag: String = "All" {
        didSet {
            filterRecipesByTag()
        }
    }
        
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupTableView()
        setupCollectionView()
        setupActivityIndicator()
        loadData()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupTableView() {
        receipeCard.register(UINib(nibName: "RecipeCardCell", bundle: nil), forCellReuseIdentifier: "RecipeCardCell")
        receipeCard.delegate = self
        receipeCard.dataSource = self
    }
    
    private func setupCollectionView() {
        categoryItem.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryItemCell")
        categoryItem.delegate = self
        categoryItem.dataSource = self
        if let layout = categoryItem.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    private func loadData() {
        if isConnectedToInternet() {
            activityIndicator.startAnimating()
            fetchRecipesFromAPI { [weak self] in
                self?.receipeCard.reloadData()
                self?.categoryItem.reloadData()
                self?.activityIndicator.stopAnimating()

            }
        } else {
            print("no internet")
            fetchRecipesFromCoreData { [weak self] in
                self?.receipeCard.reloadData()
                self?.categoryItem.reloadData()
            }
        }
    }
    
    private func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
// MARK: - Fetch Receipes from the API and Save it to Database
    private func fetchRecipesFromAPI(completion: @escaping () -> Void) {
        NetworkManager.shared.get(endpoint: "/recipes") { (result: Result<RecipeResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipeResponse):
                    self.recipes = recipeResponse.recipes
                    self.uniqueTags = ["All"] + Array(Set(self.recipes.flatMap { $0.tags }))
                    self.filterRecipesByTag()
//                    completion()
                    DatabaseManager.shared.deleteAll(RecipeEntity.self)
                    self.saveRecipesToCoreData(recipes: recipeResponse.recipes)
                    completion()
                    case .failure(let error):
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func deleteAllRecipesFromCoreData() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        do {
            let recipesToDelete = try DatabaseManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            
            for recipeEntity in recipesToDelete {
                DatabaseManager.shared.persistentContainer.viewContext.delete(recipeEntity)
            }
            
            DatabaseManager.shared.saveContext()
            print("All recipes deleted from Core Data")
            
        } catch {
            print("Error deleting recipes from Core Data: \(error.localizedDescription)")
        }
    }


    private func fetchRecipesFromCoreData(completion: @escaping () -> Void) {
        let recipes: [RecipeEntity] = DatabaseManager.shared.fetch(RecipeEntity.self)
        print("recipes frm data base",recipes.count)
        self.recipes = recipes.map { recipeEntity in
            return Recipe(
                id: Int(recipeEntity.id),
                name: recipeEntity.name ?? "",
                ingredients: recipeEntity.ingredients?.components(separatedBy: ",") ?? [],
                instructions: recipeEntity.instructions?.components(separatedBy: ",") ?? [],
                prepTimeMinutes: Int(recipeEntity.prepTimeMinutes),
                cookTimeMinutes: Int(recipeEntity.cookTimeMinutes),
                servings: Int(recipeEntity.servings),
                difficulty: Difficulty(rawValue: recipeEntity.difficulty ?? "") ?? .easy,
                cuisine: recipeEntity.cuisine ?? "",
                caloriesPerServing: Int(recipeEntity.caloriesPerServing),
                tags: recipeEntity.tags?.components(separatedBy: ",") ?? [],
                userID: Int(recipeEntity.userID),
                image: recipeEntity.image ?? "",
                rating: recipeEntity.rating,
                reviewCount: Int(recipeEntity.reviewCount),
                mealType: recipeEntity.mealType?.components(separatedBy: ",") ?? []
            )
        }
        print("recipes frm data base",recipes.count)
        self.uniqueTags = ["All"] + Array(Set(self.recipes.flatMap { $0.tags }))
        self.filterRecipesByTag()
        completion()
    }

    private func saveRecipesToCoreData(recipes: [Recipe]) {
        for recipe in recipes {
            DatabaseManager.shared.save(RecipeEntity.self) { recipeEntity in
                recipeEntity.name = recipe.name
                recipeEntity.reviewCount = Int32(recipe.reviewCount)
                recipeEntity.difficulty = recipe.difficulty.rawValue
                recipeEntity.mealType = recipe.mealType.joined(separator: ",")
                recipeEntity.tags = recipe.tags.joined(separator: ",")
                recipeEntity.image = recipe.image
                recipeEntity.rating = recipe.rating
                recipeEntity.prepTimeMinutes = Int32(recipe.prepTimeMinutes)
                recipeEntity.cookTimeMinutes = Int32(recipe.cookTimeMinutes)
                recipeEntity.servings = Int32(recipe.servings)
                recipeEntity.caloriesPerServing = Int32(recipe.caloriesPerServing)
                
            }
        }
       DatabaseManager.shared.saveContext()
       print( recipes.count)
    }
    
    private func filterRecipesByTag() {
        if selectedTag == "All" {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.tags.contains(selectedTag) }
        }
    }
    
    // MARK: - TableView Data Source and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCardCell", for: indexPath) as! RecipeCardCell
        let recipe = filteredRecipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 331
    }
    
    // MARK: - CollectionView Data Source and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uniqueTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
        cell.tagLabel.text = uniqueTags[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTag = uniqueTags[indexPath.row]
        receipeCard.reloadData()
    }
}

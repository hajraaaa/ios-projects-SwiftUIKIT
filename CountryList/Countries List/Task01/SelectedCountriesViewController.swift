import UIKit

class SelectedCountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var selectedCountries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the cell if you're not using a storyboard prototype cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell with the identifier "CountryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = selectedCountries[indexPath.row] // Get the country for the current row
        cell.textLabel?.text = country.name
        return cell
    }
}

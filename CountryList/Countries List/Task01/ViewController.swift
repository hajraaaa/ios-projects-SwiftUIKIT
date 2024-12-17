import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var markAllButton: UIButton!

    
    let alphabets = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var groupedCountries: [String: [Country]] = [:]
    var selectedCountries: [Country] = []
    var filteredCountries: [Country] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        groupedCountries = Country.getCountriesGroupedByAlphabet()
        
        nextButton.isHidden = true
        
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        markAllButton.addTarget(self, action: #selector(markAllButtonTapped), for: .touchUpInside)
        
}
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        // Save the original configuration
        guard let originalConfiguration = clearButton.configuration else { return }

        // Create a new configuration with a blue background
        var newConfiguration = originalConfiguration
        newConfiguration.background.backgroundColor = .white
        clearButton.configuration = newConfiguration

        // Clear all selected countries
        selectedCountries.removeAll()
        nextButton.isHidden = true     // Hide the 'Show Selected Countries' button
        tableView.reloadData()         // Reload the table view to reflect changes

        // Reset the button to its original configuration after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.clearButton.configuration = originalConfiguration
        }
    }

    @objc func markAllButtonTapped(_ sender: UIButton) {
        // Save the original configuration
        guard let originalConfiguration = markAllButton.configuration else { return }

        // Create a new configuration with a blue background
        var newConfiguration = originalConfiguration
        newConfiguration.background.backgroundColor = .white
        markAllButton.configuration = newConfiguration

        // Select all countries
        selectedCountries = groupedCountries.flatMap { $0.value }
        nextButton.isHidden = selectedCountries.isEmpty  // Show the 'Show Selected Countries' button if any country is selected
        tableView.reloadData()         // Reload the table view to reflect changes

        // Reset the button to its original configuration after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.markAllButton.configuration = originalConfiguration
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : alphabets.count // If searching, show a single section; otherwise, show sections for each alphabet
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCountries.count
        } else {
            let letter = alphabets[section]
            return groupedCountries[String(letter)]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        let country: Country
        if isSearching {
            country = filteredCountries[indexPath.row] // Get the country from the filtered list during search
        } else {
            let letter = alphabets[indexPath.section]
            let countries = groupedCountries[String(letter)] ?? []
            country = countries[indexPath.row]
        }
        
        // Configure the cell with country data and its checked state
        cell.configure(with: country, checked: selectedCountries.contains(where: { $0.name == country.name }))
        cell.checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        cell.checkbox.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching ? "Search Results" : String(alphabets[section])
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        let country: Country
        if isSearching {
            country = filteredCountries[sender.tag]
        } else {
            let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
                let letter = alphabets[indexPath.section]
                let countriesInSection = groupedCountries[String(letter)] ?? []
                country = countriesInSection[indexPath.row]
            } else {
                return
            }
        }
        
        // Toggle the selection state of the country
        if let index = selectedCountries.firstIndex(where: { $0.name == country.name }) {
            selectedCountries.remove(at: index) // Remove the country if it's already selected
        } else {
            selectedCountries.append(country) // Add the country if it's not selected
        }
        
        nextButton.isHidden = selectedCountries.isEmpty
        tableView.reloadData()
    }

    // Search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredCountries = Country.searchCountries(by: searchText)
            tableView.reloadData()
        }
    }
    
    // Prepare for segue to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectedCountries" {
            if let destinationVC = segue.destination as? SelectedCountriesViewController {
                destinationVC.selectedCountries = selectedCountries // Pass the selected countries to the next view controller
            }
        }
    }
}


import UIKit

class FAQViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FAQViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}
// MARK: ---- VIEW SETUP --------
extension FAQViewController {
    func setupView(){
        viewModel = FAQViewModel()
        let nib = UINib(nibName: "FAQTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FAQCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}
// MARK: ---- TABLEVIEW DATASOURCE AND DELEGATES --------
extension FAQViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFAQs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQTableViewCell else {
            return UITableViewCell()
        }
        
        let faq = viewModel.faq(at: indexPath.row)
        cell.configure(with: faq)
        print("Configuring cell with question: \(faq.question)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleExpansion(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

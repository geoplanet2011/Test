
import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barTintColor = UIColor(red: 31.0/255.0, green: 41.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        toolbar.isTranslucent = false
        return toolbar
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "ძებნა"
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 7.0
        searchBar.clipsToBounds = true
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let leftView = textField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = .gray
        }
        
        return searchBar
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "კატეგორიები"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("დამატება", for: .normal)
        return button
    }()
    
    private var listTableView: UITableView!
    
    private var items: [TableViewItem] = [
        TableViewItem(text: "სირბილი", iconName: "figure.run"),
        TableViewItem(text: "მშვილდოსნობა", iconName: "figure.archery"),
        TableViewItem(text: "ბადმინტონი", iconName: "figure.badminton"),
        TableViewItem(text: "კალათბურთი", iconName: "figure.basketball"),
        TableViewItem(text: "ბოულინგი", iconName: "figure.bowling"),
        TableViewItem(text: "ბოქსი", iconName: "figure.boxing"),
        TableViewItem(text: "ცურვა", iconName: "figure.open.water.swim"),
        TableViewItem(text: "ველოსპორტი", iconName: "figure.outdoor.cycle")
    ]
    
    private var filteredData: [TableViewItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
        filteredData = items
    }
    
    private func setupBackground () {
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 122.0/255.0, green: 168.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    }
    
    private func setupViews() {
        setupToolbar()
        setupSearchBar()
        setupTitleLabel()
        setupTableView()
        setupAddButton()
        view.layoutIfNeeded()
    }
    
    private func setupTableView() {
        
        listTableView = UITableView()
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        listTableView.backgroundColor = UIColor.clear
        view.addSubview(listTableView)
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 115)
        ])
    }
    
    private func setupSearchBar() {
        toolbar.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 15),
            searchBar.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -15),
            searchBar.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -15),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupAddButton() {
        let customColor = UIColor(red: 132.0/255.0, green: 166.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        addButton.setTitleColor(customColor, for: .normal)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 7),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if let randomItem = items.randomElement() {
            filteredData.append(randomItem)
            listTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        let item = filteredData[indexPath.row]
        cell.configure(with: item)
        
        cell.clipsToBounds = true
        // Round top corners for the first cell
           if indexPath.row == 0 {
               let cornerRadius: CGFloat = 10.0
               cell.layer.cornerRadius = cornerRadius
               cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           } else {
               cell.layer.cornerRadius = 0 
               cell.layer.maskedCorners = []
           }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showToast(message: String(indexPath.row), font: .systemFont(ofSize: 12.0))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = items
        } else {
            filteredData = items.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
        listTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder() // Hide keyboard
        filteredData = items
        listTableView.reloadData()
    }
}

//MARK - Toast
extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

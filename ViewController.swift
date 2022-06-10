import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var items = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "todoCell")
    }
// ADD  BUTTON
    @IBAction func addButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "New To Do", message: "New To Do Item", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { field in
            field.placeholder = "Enter item..."
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty{
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.set(currentItems, forKey:"items")
                        self.items.append(text)
                        self.tableView.reloadData()
                    }
                }
            }
           
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Done") { action, view, completionHandler in
            
            self.items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
            UserDefaults.standard.set(self.items, forKey:"items")
            tableView.endUpdates()
            completionHandler(true)
 
        }
        doneAction.backgroundColor = .systemGreen
        let swipe = UISwipeActionsConfiguration(actions: [doneAction])
        return swipe
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { action, view, completionHandler in
            
            self.items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            UserDefaults.standard.set(self.items, forKey: "items")
            tableView.endUpdates()
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Edit") { action, view, completionHandler in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
             alert.addTextField(configurationHandler: { (textField) in
                  textField.text = self.items[indexPath.row]
})
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
            self.items[indexPath.row] = alert.textFields!.first!.text!
            tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(self.items, forKey: "items")
            tableView.endUpdates()

        }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
}
        editAction.backgroundColor = .systemOrange
        let swipeRight = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return swipeRight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoCell {
            cell.prepareTodoName(name: items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}



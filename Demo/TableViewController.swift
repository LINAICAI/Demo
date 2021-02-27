//
//  TableViewController.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/25.
//

import UIKit

class TableViewController: UITableViewController {
    private let reuseIdentifier = "reuseIdentifier"

    private let histroyKey: String = "histroy"
    private let histroyCache: Defaults = Defaults()

    public var items: [Date]? {
        didSet {
            tableView.reloadData()
            if tableView.refreshControl?.isRefreshing == true {
                tableView.refreshControl?.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.bounds.height), animated: true)
        tableView.refreshControl?.beginRefreshing()
        tableView.refreshControl?.sendActions(for: .valueChanged)
    }

    @objc public func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) { [self] in
            items = histroyCache[histroyKey] as? Array<Date>
        }
    }

    public func showNewMessage() {
        if let _ = navigationController?.presentedViewController {
            return
        }
        let alert = UIAlertController(title: "tips", message: "new message,pull down tableview will refresh", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in

        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = items?[indexPath.row].description
        if indexPath.row == 0 {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        }

        return cell
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

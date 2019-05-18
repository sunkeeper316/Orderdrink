//
//  OrderTVC.swift
//  Orderdrink
//
//  Created by 黃德桑 on 2019/5/16.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewController {
    
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchGirls() {
        let urlString = "https://sheetdb.io/api/v1/s52vqgmtqz71x"
        
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let orders = try? decoder.decode([Order].self, from: data) {
                        self.orders = orders
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            }
            task.resume()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchGirls()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        let order = orders[indexPath.row]
        let text = "\(order.name) ,\(order.drink) ,\(order.sweet) ,\(order.ice)"
        cell.textLabel?.text = text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let order = self.orders[indexPath.row]
            let url = URL(string: "https://sheetdb.io/api/v1/s52vqgmtqz71x/name/\(order.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataorder = OrderData(data: [order])
            if let data = try? JSONEncoder().encode(dataorder) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error) in
                    
                    let decoder = JSONDecoder()
                    if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["deleted"] == 1 {
                        
                    } else {
                        print("error")
                    }
                    
                }
                task.resume()
            }
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updata"{
            let order = orders[tableView.indexPathForSelectedRow!.row]
            let updataTVC = segue.destination as! UpdataTVC
            updataTVC.order  = order
        }
    }
}

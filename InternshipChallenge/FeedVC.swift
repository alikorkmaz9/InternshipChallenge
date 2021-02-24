//
//  FeedVC.swift
//  InternshipChallenge
//
//  Created by ALI on 12.12.2020.
//  Copyright © 2020 alikorkmaz. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewTitles: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var titles = [Titles]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedVCTableViewCell
        let card: Titles
        card = titles[indexPath.row]
        cell.titleLabel.text = card.title
        let imageUrl = URL(string: "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/\(card.urlImage!)")!
        let imageData = try! Data(contentsOf: imageUrl)
        let imageArray = UIImage(data: imageData)
        cell.titleImage.image = imageArray
        return cell
    }
    
    // I create this viewWillappear func to show ActivityIndicator on the screen until the datas come from API.
    override func viewWillAppear(_ animated: Bool) {
        view = UIView()
        view.backgroundColor = UIColor(white: 3, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = true
        spinner.startAnimating()
        tableViewTitles.backgroundView = spinner
        view.addSubview(spinner)
        spinner.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTitles.delegate = self
        tableViewTitles.dataSource = self
        
        // Here is the some codes to arrange tableView constraints for the all devices.
        tableViewTitles.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitles.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewTitles.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewTitles.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewTitles.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewTitles.insetsLayoutMarginsFromSafeArea = false

        /* Below there are codes which I created to get datas from API. Here is the details;
         1) Request & Session
         2) Response & Data
         3) Parsing & JSON Serialization */
        
        // 1.
        let urlGetData = URL(string: "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/data.json")
        let session = URLSession.shared
        
        // Closure
        let task = session.dataTask(with: urlGetData!) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction (title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                // 2.
                if data != nil {
                    do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        // 3.
                        // ASYNC
                        DispatchQueue.main.async {
                            if let json = jsonResponse["items"] as? NSArray {
                                let titlesArray: NSArray = json
                                
                                for i in 0..<titlesArray.count {
                                    self.titles.append(Titles(
                                    title: (titlesArray[i] as AnyObject).value(forKey: "title") as? String,
                                    urlImage: (titlesArray[i] as AnyObject).value(forKey: "url") as? String
                                ))
                                }
                                self.tableViewTitles.reloadData()
                            }
                        }
                    } catch {
                        print("error")
                    }
                }
            }
        }
        task.resume()
    }
    
}

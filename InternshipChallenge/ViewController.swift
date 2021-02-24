//
//  ViewController.swift
//  InternshipChallenge
//
//  Created by ALI on 11.12.2020.
//  Copyright © 2020 alikorkmaz. All rights reserved.
//

import UIKit
import Firebase
import Reachability

class ViewController: UIViewController, URLSessionDataDelegate {
    @IBOutlet weak var myLabel: UILabel!
    
    let reachability = try? Reachability()
    var textLabel = ""
    
    // Showing fetchedRC on the screen
    func updateViewWithRCValues() {
        textLabel = RemoteConfig.remoteConfig().configValue(forKey: "labelText").stringValue ?? ""
        
        // Here I wrote the codes to locate the label on the center.
        myLabel.text = textLabel
        myLabel.center.x = self.view.center.x
        myLabel.center.y = self.view.center.y
    }
    
    // To setup RC Default to the Firebase
    func setupRemoteConfigDefaults() {
        let defaultValues = [
            "labelText": "Default text!" as NSObject,
        ]
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
    }
    
    // Fetching the RC values from Firebase
    func fetchRemoteConfig() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else {
                print("Got an error fetching remote values")
                return
            }
                print("Success")
                RemoteConfig.remoteConfig().activate(completion: nil)
                self.updateViewWithRCValues()
            }
        }
    
    // This function helps to delay segue until 3 seconds after the text is printed on the screen
    func delaySegue() {
        if self.myLabel.text == self.textLabel {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.performSegue(withIdentifier: "toFeedVC", sender: self )
        })
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        updateViewWithRCValues()
        fetchRemoteConfig()

        // Reachability function provides to know whether there is any internet connection or not. If there is no connection the segue cannot be performed.
        func startReachability() {
            do {
                try reachability?.startNotifier()
                
                reachability?.whenReachable = { reachability in
                    if reachability.connection == .wifi {
                        print("Reachable via wifi")
                        self.delaySegue()
                    } else if reachability.connection == .cellular {
                        print("Reachable via cellular")
                        self.delaySegue()
                    } else if reachability.connection == .unavailable {
                        print("Not reachable")
                }
                }
        } catch {
            print("Unable to start notifier")
            }
        }
        startReachability()
    }
}

    



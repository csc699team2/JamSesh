//
//  SessionsViewController.swift
//  JamSesh
//
//  Created by Monali Chuatico on 4/10/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse

class SessionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var sessionCollectionView: UICollectionView!
    
    var musicSessions = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionCollectionView.delegate = self
        sessionCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSessions()
    }
    
    func loadSessions() {
        let query = PFQuery(className:"MusicSession")
        query.includeKey("author")
        query.addDescendingOrder("createdAt")
        musicSessions.removeAll()
        query.findObjectsInBackground { (sessions, error) in
            if sessions != nil {
                for session in sessions! {
                    self.musicSessions.append(session)
                }
                print("Retrieved Music Sessions")
                self.sessionCollectionView.reloadData()
            }
            else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicSessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicSessionCell", for: indexPath) as! MusicSessionCell
        let session = musicSessions[indexPath.row]
        cell.musicSessionName.text = session["sessionName"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sessionToDetailSegue", sender: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

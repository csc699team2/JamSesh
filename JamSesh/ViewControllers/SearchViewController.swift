//
//  SearchViewController.swift
//  JamSesh
//
//  Created by Monali Chuatico on 4/10/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchControl: UISegmentedControl!
    
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var users = [PFObject]()
    var filteredUsers = [PFObject]()
    var sessions = [PFObject]()
    var filteredSessions = [PFObject]()
    var searchBarBeginEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.isHidden = true
        tableView.dataSource = self
        searchBar.delegate = self
        
        loadUsers()
        filteredUsers = users
        
        loadSessions()
        filteredSessions = sessions
        
        if UserDefaults.standard.bool(forKey: "Play") == false {
            songView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.bool(forKey: "Play") == true {
            songTitleLabel.text = UserDefaults.standard.string(forKey: "SongTitle")
            artistLabel.text = UserDefaults.standard.string(forKey: "Artist")
            playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            songView.isHidden = false
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
    }
    
    func loadUsers() {
        let query = PFUser.query()
        query!.findObjectsInBackground { (users, error) in
            if users != nil {
                for user in users! {
                    if user.objectId != PFUser.current()?.objectId {
                        self.users.append(user)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func loadSessions() {
        let query = PFQuery(className: "MusicSession")
        query.findObjectsInBackground { (sessions, error) in
            if sessions != nil {
                self.sessions = sessions!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        SoundPlayer.sharedInstance.playSound()
        
        if SoundPlayer.sharedInstance.isPlaying {
            playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            UserDefaults.standard.set(true, forKey: "Play")
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            UserDefaults.standard.set(false, forKey: "Play")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarBeginEditing {
            if searchControl.selectedSegmentIndex == 0 {
                return filteredUsers.count
            }
            else {
                return filteredSessions.count
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        if searchControl.selectedSegmentIndex == 0 {
            let user = filteredUsers[indexPath.row]
            cell.resultLabel.text = user["username"] as? String
            
            let imageFile = user["image"] as? PFFileObject ?? nil
            if imageFile != nil {
                let urlString = imageFile!.url!
                let url = URL(string: urlString)!
                cell.resultImage.af_setImage(withURL: url)
                cell.resultImage.layer.cornerRadius = cell.resultImage.frame.width/2
            }
        }
        else {
            let session = filteredSessions[indexPath.row]
            cell.resultLabel.text = session["sessionName"] as? String
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchControl.selectedSegmentIndex == 0 {
            filteredUsers = users.filter({ (user) -> Bool in
                let username = user["username"] as! String
                return username.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        }
        else {
            filteredSessions = sessions.filter({ (session) -> Bool in
                let sessionName = session["sessionName"] as! String
                return sessionName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarBeginEditing = false
        searchBar.showsCancelButton = false
        searchControl.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        songView.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarBeginEditing = true
        searchBar.showsCancelButton = true
        searchControl.isHidden = false
        tableView.isHidden = false
        songView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchControl.isHidden = false
        tableView.isHidden = false
        songView.isHidden = true
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch searchControl.selectedSegmentIndex {
        case 0:
            filteredSessions.removeAll()
        case 1:
            filteredUsers.removeAll()
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Find the user
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let user = filteredUsers[indexPath.row] as! PFUser
        
        // Get the new view controller using segue.destination.
        let profileViewController = segue.destination as! OtherProfileViewController
        
        // Pass the selected object to the new view controller.
        profileViewController.user = user
        
        tableView.deselectRow(at: indexPath, animated: true)
     }
    
}

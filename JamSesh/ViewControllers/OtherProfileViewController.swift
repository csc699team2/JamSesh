//
//  OtherProfileViewController.swift
//  JamSesh
//
//  Created by Micaella Morales on 4/20/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class OtherProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: PFUser?
    var userPlaylists = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadUserInfo()
        loadPlaylists()
        
        //sets the layout of the collection view
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*3) / 2
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func loadUserInfo() {
        let followers = user!["followersCount"] as? Int ?? 0
        let following = user!["followingCount"] as? Int ?? 0
        
        usernameLabel.text = user?.username
        followersCountLabel.text = "\(String(followers)) followers"
        followingCountLabel.text = "\(String(following)) following"
        
        //loads the profile image of user
        let imageFile = user!["image"] as? PFFileObject ?? nil
        if imageFile != nil {
            let urlString = imageFile!.url!
            let url = URL(string: urlString)!
            profileImage.af_setImage(withURL: url)
        }
    }
    
    func loadPlaylists() {
        let query = PFQuery(className:"Playlists")
        query.includeKey("author")
        query.addDescendingOrder("createdAt")
        userPlaylists.removeAll()
        query.findObjectsInBackground { (playlists, error) in
            if playlists != nil {
                for playlist in playlists! {
                    let author = playlist["author"] as! PFUser
                    if (author.objectId! == self.user!.objectId) {
                        self.userPlaylists.append(playlist)
                    }
                }
                print("Retrieved user playlists")
                self.collectionView.reloadData()
            }
            else {
                print("Error: \(String(describing: error))")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPlaylists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherPlaylistCell", for: indexPath) as! OtherPlaylistCell
        let playlist = userPlaylists[indexPath.row]
        cell.playlistLabel.text = playlist["playlistName"] as? String
        
        return cell
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

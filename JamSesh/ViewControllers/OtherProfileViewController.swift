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
    @IBOutlet weak var followButton: UIButton!
    
    let currUser = PFUser.current()
    var followed = false
    
    var user: PFUser?
    var userPlaylists = [PFObject]()
    var userFollowers = [PFUser]()
    var userFollowings = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadPlaylists()
        
        //sets the layout of the collection view
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*3) / 2
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadUserInfo()
    }
    
    func loadUserInfo() {
        usernameLabel.text = user?.username
        
        userFollowers.removeAll()
        userFollowings.removeAll()
        
        let follow = PFQuery(className: "Follow")
        follow.includeKeys(["follower", "following"])
        follow.findObjectsInBackground { (followLists, error) in
            if followLists != nil {
                for item in followLists! {
                    let follower = item["follower"] as! PFUser
                    let following = item["following"] as! PFUser
                    if follower.objectId == self.user?.objectId {
                        self.userFollowings.append(following)
                    }
                    else if following.objectId == self.user?.objectId {
                        self.userFollowers.append(follower)
                    }
                }
                print("Followers: \(String(self.userFollowers.count))")
                print("Following: \(String(self.userFollowings.count))")
            }
        }
        
        followersCountLabel.text = "\(String(userFollowers.count)) followers"
        followingCountLabel.text = "\(String(userFollowings.count)) following"
        
        for follower in userFollowers {
            if follower.objectId == currUser?.objectId {
                followed = true
                followButton.setTitle("Unfollow", for: .normal)
                break
            }
        }
        
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
    
    @IBAction func onFollowButton(_ sender: Any) {
        if !followed{
            let follow = PFObject(className: "Follow")
            
            follow["follower"] = currUser
            follow["following"] = user
            
            follow.saveInBackground { (success, error) in
                if success {
                    self.followed = true
                    self.followButton.setTitle("Unfollow", for: .normal)
                    print("followed!")
                }
                else {
                    print("error!")
                }
            }
        }
        loadUserInfo()
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

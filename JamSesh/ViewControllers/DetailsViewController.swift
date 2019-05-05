//
//  DetailsViewController.swift
//  JamSesh
//
//  Created by Monali Chuatico on 4/10/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var session: PFObject?
    var songs = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let playlist = session!["playlist"] as? PFObject
        songs = playlist!["songs"] as! [PFObject]
        
        addSongs()
        getFirstSong()
        addSongObserver()
    }
    
    func getFirstSong(){
        let songTitle = songs[0]["songTitle"] as! String
        let artist = songs[0]["Artist"] as! String
        
        songTitleLabel.text = songTitle
        artistLabel.text = artist
    }
    
    func addSongs(){
        SoundPlayer.sharedInstance.clearPlayer()
        for song in songs {
            //let filename = song["fileName"] as! String
            SoundPlayer.sharedInstance.addSong(song: song)
        }
        SoundPlayer.sharedInstance.playAllSongs()
    }
    
    func addSongObserver(){
        for song in songs {
            let filename = song["fileName"] as! String
            let playerItem = SoundPlayer.sharedInstance.getSongItem(filename: filename)
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        let song = SoundPlayer.sharedInstance.getSong(next: true)
        
        let songTitle = song["songTitle"] as! String
        let artist = song["Artist"] as! String
        
        songTitleLabel.text = songTitle
        artistLabel.text = artist
        
        print("Next Song")
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        SoundPlayer.sharedInstance.playAllSongs()
        if SoundPlayer.sharedInstance.isQueuePlaying {
            playButton.setImage(UIImage(named: "pause-1"), for: UIControl.State.normal)
        }
        else {
            playButton.setImage(UIImage(named: "play-1"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func onForwardButton(_ sender: Any) {
        SoundPlayer.sharedInstance.nextSong()
        
        let song = SoundPlayer.sharedInstance.getSong(next: false)
        
        let songTitle = song["songTitle"] as! String
        let artist = song["Artist"] as! String
        
        songTitleLabel.text = songTitle
        artistLabel.text = artist
    }
    
    @IBAction func onPreviousButton(_ sender: Any) {
        SoundPlayer.sharedInstance.prevSong()
        
        let song = SoundPlayer.sharedInstance.getSong(next: false)
        
        let songTitle = song["songTitle"] as! String
        let artist = song["Artist"] as! String
        
        songTitleLabel.text = songTitle
        artistLabel.text = artist
    }
    
    @IBAction func detailToSessionSegue(_ sender: Any) {
        performSegue(withIdentifier: "detailToSessionSegue", sender: nil)
    }
    
    @IBAction func detailToChatSegue(_ sender: Any) {
        performSegue(withIdentifier: "detailToChatSegue", sender: nil)
    }
   
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailToChatSegue" {
            if let chatVC = segue.destination as? ChatViewController {
                chatVC.session = session
            }
        }
    }
    
}

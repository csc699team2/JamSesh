//
//  PlaylistViewController.swift
//  JamSesh
//
//  Created by Micaella Morales on 4/25/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    var playlist: PFObject?
    var songs: [PFObject]?
    static var audioPlayer = AVAudioPlayer()
    static var audioIsPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        playlistNameLabel.text = playlist!["playlistName"] as? String
        songs = playlist!["songs"] as? [PFObject] ?? []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        songs = playlist!["songs"] as? [PFObject] ?? []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        let song = songs![indexPath.row]
        cell.song = song
        cell.songTitleLabel.text = song["songTitle"] as? String
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let addSongsViewController = segue.destination as! AddSongsViewController
        
        // Pass the selected object to the new view controller.
        addSongsViewController.playlist = playlist
    }

}

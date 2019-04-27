//
//  SongCell.swift
//  JamSesh
//
//  Created by Micaella Morales on 4/26/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class SongCell: UITableViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    
    var audioPlayer = PlaylistViewController.audioPlayer
    var song: PFObject?
    
    @IBAction func play(_ sender: Any) {
        let songFilename = song?["fileName"] as? String
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: songFilename!, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
        }
        catch {
            print(error)
        }
        
        if !PlaylistViewController.audioIsPlaying {
            audioPlayer.play()
            PlaylistViewController.audioIsPlaying = true
        }
        else {
            audioPlayer.pause()
            PlaylistViewController.audioIsPlaying = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

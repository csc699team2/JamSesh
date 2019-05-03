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
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var song: PFObject?
    
    @IBAction func play(_ sender: Any) {
        let songFilename = song?["fileName"] as? String
        
        SoundPlayer.sharedInstance.setSong(fileName: songFilename!)
        SoundPlayer.sharedInstance.playSong()
        

        if SoundPlayer.sharedInstance.isAudioPlaying {
            playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
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

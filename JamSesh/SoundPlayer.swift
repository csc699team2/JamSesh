//
//  SoundPlayer.swift
//  JamSesh
//
//  Created by Micaella Morales on 4/29/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import AVFoundation


class SoundPlayer {
    
    // Singleton in order to access the player from 'everywhere'
    class var sharedInstance : SoundPlayer {
        struct Static {
            static let instance : SoundPlayer = SoundPlayer()
        }
        return Static.instance
    }
    
    // Properties
    var error:NSError?
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    
    func setSong(fileName: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
        }
        catch {
            print(error)
        }
    }
    
    func playSound() {
        if (!isPlaying) {
            audioPlayer.play()
            isPlaying = true
        }
        else {
            audioPlayer.stop()
            isPlaying = false
        }
    }
    
    
}

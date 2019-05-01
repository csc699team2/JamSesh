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
    var queuePlayer = AVQueuePlayer()
    var isAudioPlaying = false
    var isQueuePlaying = false
    
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
    
    func addSong(fileName: String) {
        let playerItem = AVPlayerItem(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp3")!))
        queuePlayer.insert(playerItem, after:nil)
    }
    
    func playSong() {
        if (!isAudioPlaying) {
            audioPlayer.play()
            isAudioPlaying = true
        }
        else {
            audioPlayer.stop()
            isAudioPlaying = false
        }
    }
    
    func playAllSongs() {
        if (!isQueuePlaying) {
            queuePlayer.play()
            isQueuePlaying = true
        }
        else {
            queuePlayer.pause()
            isQueuePlaying = false
        }
    }
    
    func nextSong() {
        queuePlayer.advanceToNextItem()
    }
    
    func prevSong() {
        let playerItems = queuePlayer.items()
    }
    
    
}

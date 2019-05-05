//
//  SoundPlayer.swift
//  JamSesh
//
//  Created by Micaella Morales on 4/29/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import AVFoundation
import Parse


class SoundPlayer {
    
    // Singleton in order to access the player from 'everywhere'
    class var sharedInstance : SoundPlayer {
        struct Static {
            static let instance : SoundPlayer = SoundPlayer()
        }
        return Static.instance
    }
    
    // Properties
    var audioPlayer = AVAudioPlayer()
    var queuePlayer = AVQueuePlayer()
    var isAudioPlaying = false
    var isQueuePlaying = false
    var playerItems = [String:AVPlayerItem]()
    var filenames = [String]()
    var songs = [PFObject]()
    
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
    
    func addSong(song: PFObject) {
        let fileName = song["fileName"] as! String
        let playerItem = AVPlayerItem(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp3")!))
        songs.append(song)
        queuePlayer.insert(playerItem, after:nil)
        playerItems[fileName] = playerItem
        filenames.append(fileName)
    }
    
    func getSongItem(filename: String) -> AVPlayerItem {
        let playerItem = playerItems[filename] as! AVPlayerItem
        return playerItem
    }
    
    func getSong(next: Bool) -> PFObject {
        let currPlayerItem = queuePlayer.currentItem
        
        //gets the index of the previous player item
        var index = 0
        for playerItem in playerItems {
            if playerItem.value == currPlayerItem {
                index = filenames.firstIndex(of: playerItem.key)!
                if (next && (index != songs.count-1)) {
                    index += 1
                }
                break
            }
        }
        
        let song = songs[index]
        return song
    }
    
    func removeSong(filename: String, index: Int) {
        let playerItem = playerItems[filename] as! AVPlayerItem
        songs.remove(at: index)
        queuePlayer.remove(playerItem)
        playerItems.removeValue(forKey: filename)
        filenames.remove(at: index)
    }
    
    func clearPlayer(){
        queuePlayer.pause()
        songs.removeAll()
        queuePlayer.removeAllItems()
        playerItems.removeAll()
        filenames.removeAll()
        isQueuePlaying = false
    }
    
    func playSong() {
        if (!isAudioPlaying) {
            if (isQueuePlaying) {
                queuePlayer.pause()
                isQueuePlaying = false
            }
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
            if (isAudioPlaying) {
                audioPlayer.stop()
                isAudioPlaying = false
            }
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
        let currPlayerItem = queuePlayer.currentItem
        
        //gets the index of the previous player item
        var index = 0
        for playerItem in playerItems {
            if playerItem.value == currPlayerItem {
                index = filenames.firstIndex(of: playerItem.key)! - 1
                print("index: \(index)")
                break
            }
        }
        
        //sets the current player time to the previous playerItem
        if index >= 0 {
            let filename = filenames[index]
            print("song: \(filename)")
            let playerItem = playerItems[filename] as! AVPlayerItem
            
            queuePlayer.replaceCurrentItem(with: playerItem)
            queuePlayer.seek(to: CMTime.zero)
        }
    }
    
    
}

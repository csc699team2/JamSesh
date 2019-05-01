//
//  SettingsViewController.swift
//  JamSesh
//
//  Created by Monali Chuatico on 4/10/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoutButton.layer.cornerRadius = 15
        
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
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LogInViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        SoundPlayer.sharedInstance.playSong()
        
        if SoundPlayer.sharedInstance.isAudioPlaying {
            playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            UserDefaults.standard.set(true, forKey: "Play")
        }
        else {
            playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            UserDefaults.standard.set(false, forKey: "Play")
        }
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

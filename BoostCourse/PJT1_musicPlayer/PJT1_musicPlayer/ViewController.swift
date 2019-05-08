//
//  ViewController.swift
//  PJT1_musicPlayer
//
//  Created by mong on 04/12/2018.
//  Copyright © 2018 mong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    
    var player: AVAudioPlayer!
    var timer: Timer!
    
    func initializePlayer(){
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else{
            print("Cannot bring Music File!!")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError{
            print("player init fail")
            print("CODE : \(error.code), MESSAGE : \(error.localizedDescription)")
        }
        
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    
    func updateTimeLabelText(time: TimeInterval){
        let minute: Int = Int(time/60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1)*100)
        
        let timeText:String = String(format: "%02ld:%02ld:%02ld", minute,second,milisecond)
        
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
            
            // 재생 아닐때 항상 버튼 deSelected로 해두면 이미지 알아서 바뀜.
            if (!self.player.isPlaying){
                self.playPauseButton.isSelected = false
                
            }
        })
        self.timer.fire()
        
        
        if (self.progressSlider.value == self.progressSlider.maximumValue){
            self.player.pause()
        }
    }
    func invalidateTime(){
        self.timer.invalidate()
        self.timer = nil
    }
    


    @IBAction func touchPlayPause_Btn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.player.play()
        } else{
            self.player.pause()
        }
        
        if sender.isSelected{
            self.makeAndFireTimer()
        } else{
            self.invalidateTime()
        }
    }
    @IBAction func sliderValueChanged_Btn(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking{return}
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializePlayer()
        
    }
}


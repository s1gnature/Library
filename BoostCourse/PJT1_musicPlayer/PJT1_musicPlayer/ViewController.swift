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
    // MARK: TEST -> 메소드 사이에서 마킹을 해서 구분 가능하게함.
    
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
        })
        self.timer.fire()
        
        // 끝났을때 pause 버튼이 play 버튼으로 안바뀜...
        if (self.progressSlider.value == self.progressSlider.maximumValue){
            self.player.pause()
        }
    }
    func invalidateTime(){
        self.timer.invalidate()
        self.timer = nil
    }
    
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializePlayer()
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
    
}


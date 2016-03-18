//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Steven Hertz on 6/21/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  var audioPlayer : AVAudioPlayer!
  var audioPlayer2 : AVAudioPlayer!
  var error : NSError?
  var receivedAudio: RecordedAudio!
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  
  @IBAction func slowPlay(sender: AnyObject) {
    playAudio(theRate: 0.5)
  }

  @IBAction func fastPlay(sender: AnyObject) {
    playAudio(theRate: 1.5)
  }
  
  @IBAction func chipmunkPlay(sender: AnyObject) {
    playAudioWithPitch(1000)
  }
  
  @IBAction func darthVaderPlay(sender: AnyObject) {
    playAudioWithPitch(-1000)
  }
  
  @IBAction func stopPlay(sender: AnyObject) {
    stopPlayingAll()
  }
  
  @IBAction func echoPlay(sender: AnyObject) {
    playAudio(theRate: 1.0)
    let delay:NSTimeInterval = 0.1
    var playtime:NSTimeInterval
    playtime = audioPlayer2.deviceCurrentTime + delay
    audioPlayer2.stop()
    audioPlayer2.currentTime = 0
    audioPlayer2.volume = 0.8;
    audioPlayer2.playAtTime(playtime)
  }
  
  @IBAction func reverbPlay(sender: AnyObject) {
    stopPlayingAll()
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    let reverb = AVAudioUnitReverb()
    reverb.loadFactoryPreset(.Cathedral)
    reverb.wetDryMix = 40
    audioEngine.attachNode(reverb)
    audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
    audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    do {
      try audioEngine.start()
    }
    catch let error as NSError{
        print(error.localizedDescription)
    }
    audioPlayerNode.play()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    audioEngine = AVAudioEngine()
    audioFile = try? AVAudioFile(forReading: receivedAudio.fielPathUrl)
    do {
      audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.fielPathUrl)
    } catch let error1 as NSError {
      error = error1
      audioPlayer = nil
    }
    audioPlayer.enableRate = true
    do {
      audioPlayer2 = try AVAudioPlayer(contentsOfURL: receivedAudio.fielPathUrl)
    } catch let error1 as NSError {
      error = error1
      audioPlayer2 = nil
    }
    audioPlayer2.enableRate = true
  }
  
  func stopPlayingAll() {
    audioPlayer.currentTime = 0.0
    audioPlayer.stop()
    audioPlayer2.stop()
    audioPlayer2.currentTime = 0.0
    audioEngine.stop()
    audioEngine.reset()
  }
  
  func playAudio( theRate theRate: Float) {
    stopPlayingAll()
    audioPlayer.rate = theRate
    audioPlayer.volume = 1.0
    audioPlayer.play()
  }
  
  func playAudioWithPitch(pitch: Float){
    stopPlayingAll()
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    let changePitch = AVAudioUnitTimePitch()
    changePitch.pitch = pitch
    audioEngine.attachNode(changePitch)
    audioEngine.connect(audioPlayerNode, to: changePitch, format: nil)
    audioEngine.connect(changePitch, to: audioEngine.outputNode, format: nil)
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    do {
        try audioEngine.start()
    }
    catch let error as NSError{
        print(error.localizedDescription)
    }
    audioPlayerNode.play()
    }
  
}

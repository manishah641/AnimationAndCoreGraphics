//
//  ShoppingCartViewController.swift
//  ShoppingApp
//
//  Created by syed on 09/10/2021.
//

import UIKit
import Vision
import AVFoundation
import AVKit

class ShoppingCartViewController: UIViewController{
    
    var displayLink :CADisplayLink?
    let titleText = "The text Should be show up in nice animation, so i look like a story.so we can make app for kids with good stories"
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    private let button:UIButton = {
        let button = UIButton()
        button.setTitle("Play video", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        titleLabel.frame = view.frame
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
//        startDisplayLink()
        view.addSubview(button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 30, y: view.bottom-200, width: view.width-60, height: 50)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
       
    }
    @objc private func handleGesture(){
                titleLabel.text=""
                var charIndex = 0.0
                for letter in titleText{
                    Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                        self.titleLabel.text?.append(letter)
                    }
                    charIndex += 1
                    }
    }
    @objc func didTapButton(){
        if let url:URL = URL(string: "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"){
            print(url)
            playVideo(with: url)
        }
    }
    private func playVideo(with url:URL){
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true){ vc.player?.play()}
    }
    
    
    
    private func startDisplayLink(){
        // make sure to stop a previous running display link
        stopDisplayLink()
        // reset start time
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self,
                                        selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    func stopDisplayLink(){
        displayLink?.invalidate()
        displayLink = nil
    }
    
    
    var startTime:Double = 500
    var endValue:Double = 0
    let animationDuration = 8.0
    let animationStartDate = Date()
    
    
    @objc func handleUpdate(){
        print("Handling update")
        let now=Date()
        endValue = Double(titleText.count)
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration{
            //stopDisplaylink
            titleLabel.text = titleText
            stopDisplayLink()
        }else {
//        self.titleLabel.text?.append(letter)
        }
        
        
        
        
//        if elapsedTime > animationDuration {
//            self.titleLabel.text = String(format: "%.0f", endValue)
//            stopDisplayLink()
//
//        }else {
//            let percantage = elapsedTime/animationDuration
//
//            let value = startTime+percantage*(endValue-startTime)
//            self.titleLabel.text = String(format: "%.0f", value)
//        }
        
        
        
        
        
        //        self.countingLabel.text = "\(startvalue)"
        //        startvalue += 1
        //        if startvalue > endValue {
        //            startvalue = endValue
        //        }
        //        let seconds = Date().timeIntervalSince1970
        //        print(seconds)
        //        self.countingLabel.text = "\(seconds)"
    }
    
    
}


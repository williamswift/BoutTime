//
//  ViewController.swift
//  BoutTime
//
//  Created by William Vivas on 4/28/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

protocol GameType {
    func startNewGame()
}

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var events = HistoricalEventModel()
    var score: Int = 0
    var numQuestionsAnswered: Int = 0
    let numQuestionsInRound: Int = 6
    var timer = Timer()
    let secondsPerQuestion: Double = 60
    var secondsLeft: Int = 0

    @IBOutlet weak var eventLabel0: UILabel!
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    
    @IBOutlet weak var eventLinkButton0: UIButton!
    @IBOutlet weak var eventLinkButton1: UIButton!
    @IBOutlet weak var eventLinkButton2: UIButton!
    @IBOutlet weak var eventLinkButton3: UIButton!
    
    @IBOutlet weak var downButton0: UIButton!
    @IBOutlet weak var downButton1: UIButton!
    @IBOutlet weak var downButton2: UIButton!
    @IBOutlet weak var upButton1: UIButton!
    @IBOutlet weak var upButton2: UIButton!
    @IBOutlet weak var upButton3: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupArrowImages()
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: During rounds
    
    func startTimer() {
        secondsLeft = Int(secondsPerQuestion)
        tick() // start and show the new timer right away
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
    }
    
    func tick() {
        let minutes: Int = secondsLeft / 60
        let seconds: Int = secondsLeft % 60
        timerLabel.text = "\(minutes):" + String(format: "%02d", seconds)
        if secondsLeft == 0 {
            checkAnswer()
        }
        secondsLeft -= 1
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        events.rearrangeEvents(sender.tag, indexB: sender.tag + 1)
        updateEventLabels()
    }
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        events.rearrangeEvents(sender.tag, indexB: sender.tag - 1)
        updateEventLabels()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer()
        }
    }
    
    // MARK: After rounds
    
    func checkAnswer() {
        
        bottomInfoLabel.text = "Tap events to learn more"
        enableLinkButtons()
        
        timer.invalidate()
        
        numQuestionsAnswered += 1
        
        timerLabel.isHidden = true
        nextRoundButton.isHidden = false
        
        enableArrowButtons(false)
        
        if events.inOrder() {
            score += 1
            nextRoundButton.setImage(UIImage(named: "next_round_success.png"), for: UIControlState())
            nextRoundButton.setImage(UIImage(named: "next_round_success.png"), for: .highlighted)
        } else {
            nextRoundButton.setImage(UIImage(named: "next_round_fail.png"), for: UIControlState())
            nextRoundButton.setImage(UIImage(named: "next_round_fail.png"), for: .highlighted)
        }
    }

    
    @IBAction func eventLinkTapped(_ sender: UIButton) {
        let website = events[sender.tag].website
        let svc = SFSafariViewController(url: URL(string: website)!)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func nextRoundButtonTapped(_ sender: UIButton) {
        
        bottomInfoLabel.text = "Shake to complete"
        enableLinkButtons(false)
        
        enableArrowButtons()
        
        if numQuestionsAnswered == numQuestionsInRound {
            performSegue(withIdentifier: "gameEnd", sender: nil)
        } else {
            startNextRound()
        }
    }
    
    func startNextRound() {
        events.getNewEvents()
        updateEventLabels()
        
        nextRoundButton.isHidden = true
        timerLabel.isHidden = false
        
        startTimer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsVC = segue.destination as? ResultsViewController {
            resultsVC.score = score
            resultsVC.numQuestionsInRound = numQuestionsInRound
            resultsVC.delegate = self
        }
    }
    
    // MARK: Helper methods
    
    func setupArrowImages() {
        downButton0.setImage(UIImage(named: "down_full_selected.png"), for: .highlighted)
        downButton1.setImage(UIImage(named: "down_half_selected.png"), for: .highlighted)
        downButton2.setImage(UIImage(named: "down_half_selected.png"), for: .highlighted)
        upButton1.setImage(UIImage(named: "up_half_selected.png"), for: .highlighted)
        upButton2.setImage(UIImage(named: "up_half_selected.png"), for: .highlighted)
        upButton3.setImage(UIImage(named: "up_full_selected.png"), for: .highlighted)
    }
    
    // enable during rounds, disable after rounds
    func enableArrowButtons(_ enable: Bool = true) {
        downButton0.isEnabled = enable
        downButton1.isEnabled = enable
        downButton2.isEnabled = enable
        upButton1.isEnabled = enable
        upButton2.isEnabled = enable
        upButton3.isEnabled = enable
    }
    
    // enable after rounds, disable during rounds
    func enableLinkButtons(_ enable: Bool = true) {
        eventLinkButton0.isEnabled = enable
        eventLinkButton1.isEnabled = enable
        eventLinkButton2.isEnabled = enable
        eventLinkButton3.isEnabled = enable
    }
    
    func updateEventLabels() {
        eventLabel0.text = events[0].description
        eventLabel1.text = events[1].description
        eventLabel2.text = events[2].description
        eventLabel3.text = events[3].description
    }
    
    func resetStats() {
        numQuestionsAnswered = 0
        score = 0
    }
}

extension ViewController: GameType {
    func startNewGame() {
        resetStats()
        startNextRound()
    }
}

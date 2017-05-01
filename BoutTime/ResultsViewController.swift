//
//  ResultsViewController.swift
//  BoutTime
//
//  Created by William Vivas on 4/30/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var score: Int!
    var numQuestionsInRound: Int!
    var delegate: GameType!
    
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score)/\(numQuestionsInRound)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playAgainTapped() {
        dismiss(animated: true, completion: nil)
        delegate.startNewGame()
    }
}

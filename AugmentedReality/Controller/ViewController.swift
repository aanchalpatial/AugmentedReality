//
//  ViewController.swift
//  AugmentedReality
//
//  Created by Aanchal Patial on 23/08/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func magicDice(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDice", sender: self)
    }
    
    @IBAction func magicScale(_ sender: UIButton) {
        performSegue(withIdentifier: "goToScale", sender: self)
    }
    
    @IBAction func magicNewspaper(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNewspaper", sender: self)
    }
    
    @IBAction func magicPokemon(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPokemon", sender: self)
    }
}


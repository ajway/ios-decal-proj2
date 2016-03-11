//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var correctTextLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var incorrectTextView: UITextView!
    @IBOutlet weak var startOverButton: UIButton!
    
    var validInput = true
    var correctTextDisplay:String = ""
    var correctLetters:[Character] = []
    var incorrectLetters:[Character] = []
    var phraseArray:[Character] = []
    var masterPhrase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        masterPhrase = phrase
        
        phraseArray = Array(phrase.characters)
        hangmanImage.image = UIImage(named: "hangman1.gif")
        
        correctTextDisplay = ""
        
        for i in phrase.characters.indices {
            if (phrase[i] == " ") {
                correctTextDisplay += "  "
            } else {
                correctTextDisplay += "-"
            }
        }
        
        correctTextLabel.text = correctTextDisplay
        
        guessButton.enabled = false
        guessTextField.clearsOnBeginEditing = true
        
        print("\n*****************************")
        print(phrase)
        print("*****************************\n")
    }
    @IBAction func checkInput(sender: AnyObject) {
        validInput = true
        guessButton.enabled = true
        if (guessTextField.text?.characters.count == 1) { //is length 1
            //check if it is a letter
            for c in guessTextField.text!.characters {
                if (!(c >= "a" && c <= "z") && !(c >= "A" && c <= "Z")) {
                    validInput = false
                    guessButton.enabled = false
                }
            }
        } else { //not length 1
            validInput = false
            guessButton.enabled = false
        }

    }
    @IBAction func guessButtonPressed(sender: AnyObject) {
        if (validInput) {
            let adjustedGuess = guessTextField.text?.uppercaseString
            let guess = Array(adjustedGuess!.characters)[0]
            let correct = phraseArray.contains(guess)
            guessTextField.text = ""
            
            if (correct) {
                var winGame = true
                if (!correctLetters.contains(guess)) {
                    correctLetters.append(guess)
                }
                correctTextDisplay = ""
                for i in phraseArray.indices {
                    if (phraseArray[i] == " ") {
                        correctTextDisplay += "  "
                    } else {
                        if (correctLetters.contains(phraseArray[i])) {
                            correctTextDisplay += String(phraseArray[i]).uppercaseString
                        } else {
                            correctTextDisplay += "-"
                            winGame = false
                        }
                    }
                }
                correctTextLabel.text = correctTextDisplay
                if (winGame) { //Win Game Over - True
                    let alert = UIAlertController(title: "You Win", message: "Feel free to play again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated:true, completion: nil)
                    guessButton.enabled = false
                }
            } else {
                if (!incorrectLetters.contains(guess)) {
                    incorrectLetters.append(guess)
                    incorrectLetters.append(" ")
                }
                incorrectTextView.text = "Incorrect Letters: " + String(incorrectLetters)
                
                
                if ((incorrectLetters.count/2 + 1) < 7) { //Lose Game Over - False
                    hangmanImage.image = UIImage(named: "hangman" + "\(incorrectLetters.count/2 + 1)" + ".gif")
                }
                else { //Lose Game Over - True
                    hangmanImage.image = UIImage(named: "hangman7.gif")
                    let message = "The phrase was \"" + masterPhrase + "\""
                    let alert = UIAlertController(title: "You Lost", message: message, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated:true, completion: nil)
                    guessButton.enabled = false
                }
            }
                
        }
        
    }
    @IBAction func startOverButtonPressed(sender: AnyObject) {
        validInput = true
        correctTextDisplay = ""
        correctLetters = []
        incorrectLetters = []
        incorrectTextView.text = ""
        phraseArray = []
        masterPhrase = ""
        viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

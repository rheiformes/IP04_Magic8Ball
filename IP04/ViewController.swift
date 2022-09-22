//
//  ViewController.swift
//  IP04
//
//  Created by Rai, Rhea on 9/22/22.
//

import UIKit

class ViewController: UIViewController {

    var screenWidth: Int = 0
    var screenHeight: Int = 0
    let xBuffer = 10
    let yBuffer = 100
    
    var bias:Int = 0 //0 = normal: positive + noncommital + negative For every increase, it should be bias * positive/negative + noncommital + opposite:negative/positive
    
    
    var promptLbl = UILabel()
    var answerLbl = UILabel()
        
    let questionText:String = "Think of your question...shake the magic 8 ball when ready"
    var answerText:String = ""
    
    
    
    
    
    let allMessages: [String] = ["It is certain", "Reply hazy, try again", "Don’t count on it", "It is decidedly so","Ask again later","My reply is no","Without a doubt","Better not tell you now","My sources say no","Yes definitely", "Cannot predict now","Outlook not so good", "You may rely on it", "Concentrate and ask again","Very doubtful","As I see it, yes", "Most likely","Outlook good","Yes", "Signs point to yes"]
    let negative: [String] = [ "Don’t count on it", "My reply is no", "My sources say no","Outlook not so good","You may rely on it", "Very doubtful"]
    let positive: [String] = ["It is certain", "It is decidedly so","Without a doubt","Yes definitely", "You may rely on it","As I see it, yes", "Most likely","Outlook good","Yes", "Signs point to yes"]
    let noncommital: [String] = ["Reply hazy, try again","Ask again later","Better not tell you now","Cannot predict now","Concentrate and ask again"]
    var questionAnswers: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set screen bounds
        let screenBounds: CGRect = UIScreen.main.bounds
        screenWidth = Int(screenBounds.width)
        screenHeight = Int(screenBounds.height)
        
        //set info
        promptLbl.frame = CGRect(x: xBuffer, y: yBuffer, width: screenWidth - 2*xBuffer, height: screenHeight/8)
        promptLbl.text = questionText
        promptLbl.textAlignment = NSTextAlignment.center
        promptLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        promptLbl.numberOfLines = 0
        promptLbl.textColor = UIColor.black
        view.addSubview(promptLbl)
        
        
        
        /*
            //testing
            setAnswers()
            print(shake())
        */
        
        
            
        
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            answerText = shake()
            updateUI()
        }
    }

    func updateUI() {
        //change text
    }
    
    func shake() -> String {
        return questionAnswers[ Int.random(in: 0...questionAnswers.count-1) ]
    }
    
    func setAnswers() {
        if(bias<0) {
            questionAnswers = positive + multiplyArrays(array: negative, bias: abs(bias)) + noncommital
        }
        else if(bias>0) {
            questionAnswers = multiplyArrays(array: positive, bias: abs(bias)) + negative + noncommital
        }
        else {
            questionAnswers = positive + negative + noncommital
        }
    }
    
    func multiplyArrays(array: [String], bias: Int) -> [String] {
        var n = 0
        var tempArray:[String] = array
        while (n < bias) {
            tempArray += array
            n += 1
        }
        return tempArray
    }

}


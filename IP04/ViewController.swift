//
//  ViewController.swift
//  IP04
//
//  Created by Rai, Rhea on 9/22/22.
//

import UIKit

class ViewController: UIViewController {

    //screen values
    var screenWidth: Int = 0
    var screenHeight: Int = 0
    let xBuffer = 10
    let yBuffer = 100
    
    
    //extension: adding bias value to somewhat influence your destiny
    var bias:Int = 0 //0 = normal: positive + noncommital + negative For every increase, it should be bias * positive/negative + noncommital + opposite:negative/positive
    var biasLbl = UILabel()
    var biasIncButton = UIButton()
    var biasDecButton = UIButton()
    
    //label/text for the screen
    var promptLbl = UILabel()
    var answerLbl = UILabel()
        
    let questionText:String = "Think of your question...shake the magic 8 ball when ready"
    var answerText:String = ""
   
    //label for 8 ball 'circle'
    var ballLbl = UILabel()
    
    //collections of all images. The actual questionAnswers per question will change depending on the bias (a weighted combination of the different lists)
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
        
        //set 8 ball label
        answerLbl.frame = CGRect(x: screenWidth/2 - screenWidth/6, y: screenHeight/2, width: screenWidth/3, height: screenHeight/6)
        answerLbl.text = answerText
        answerLbl.textAlignment = NSTextAlignment.center
        answerLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        answerLbl.numberOfLines = 0
        answerLbl.textColor = UIColor.black
        answerLbl.backgroundColor = UIColor.white
        view.addSubview(answerLbl)
        
        //set 8 ball graphic/label in back
        let expanded:CGFloat = CGFloat(yBuffer)
        ballLbl.frame = CGRect(x: answerLbl.frame.minX - expanded, y: answerLbl.frame.minY - expanded, width: answerLbl.frame.width + 2*expanded, height: answerLbl.frame.height + 2*expanded)
        ballLbl.backgroundColor = UIColor.black
        ballLbl.layer.masksToBounds = true
        ballLbl.layer.cornerRadius = ballLbl.frame.width / 2
        view.addSubview(ballLbl)
        /*
            //testing
            setAnswers()
            print(shake())
        */
        
        self.view.bringSubviewToFront(answerLbl)
        
        
        //extension: add bias level control (buttons/UI/functionality)
        biasLbl.frame = CGRect(x: CGFloat(xBuffer), y: CGFloat(screenHeight - 3 * yBuffer/2), width: CGFloat((screenWidth-2*xBuffer)), height: CGFloat(screenHeight/16))
        biasLbl.text = "Do you believe destiny is in your own hands? Bias: \(bias)"
        biasLbl.font = UIFont(name: "HelveticaNeue",size: 14)
        biasLbl.backgroundColor = UIColor.systemBlue
        view.addSubview(biasLbl)
        
        biasIncButton.frame = CGRect(x: biasLbl.frame.minX, y: biasLbl.frame.maxY, width: biasLbl.frame.width/2, height: biasLbl.frame.height)
        biasIncButton.setTitle(" + INCREASE BIAS", for: .normal)
        biasIncButton.backgroundColor = UIColor.systemGreen
        biasIncButton.addTarget(self, action: #selector(incBias), for: .touchUpInside)
        view.addSubview(biasIncButton)
        
        biasDecButton.frame = CGRect(x: biasLbl.frame.minX + biasIncButton.frame.width, y: biasLbl.frame.maxY, width: biasLbl.frame.width/2, height: biasLbl.frame.height)
        biasDecButton.setTitle(" + DECREASE BIAS", for: .normal)
        biasDecButton.backgroundColor = UIColor.systemRed
        biasDecButton.addTarget(self, action: #selector(decBias), for: .touchUpInside)
        view.addSubview(biasDecButton)
        
        self.view = view
        
    }

    //buttons that increase/decrease bias level
    @objc func incBias() {
        bias+=10
        setAnswers()
        updateUI()
    }
    @objc func decBias() {
        bias-=10
        setAnswers()
        updateUI()
    }

   //animate the ball to shake (sourced from stack overflow: https://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
    
    func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        ballLbl.layer.add(animation, forKey: "shake")
        answerLbl.layer.add(animation, forKey: "shake")
    }

    
    
    //adding shake function for hardware
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            answerText = shake()
            shakeAnimation()
            updateUI()
        }
    }

    //update the UI look (called for every question)
    func updateUI() {
        answerLbl.text = answerText
        biasLbl.text = "Do you believe destiny is in your own hands? Bias: \(bias)"
    }
    
    //allow to get answer randomly
    func shake() -> String {
        setAnswers()
        return questionAnswers[ Int.random(in: 0...questionAnswers.count-1) ]
    }
    
    //weights the answers allowed according to bias level
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
    
    //helper function so can weight the answers by adding multiple of a certain array (positive or negative answer list)
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


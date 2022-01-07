//
//  ViewController.swift
//  KennyiYakalaSuleymanTulbur
//
//  Created by Süleyman Tülbür on 5.01.2022.
//

import UIKit

class ViewController: UIViewController {
    var width = CGFloat()
    var height = CGFloat()
    
    let counterLabel = UILabel()
    let remainingLabel = UILabel()
    let scoreLabel = UILabel()
    let highScoreLabel = UILabel()
    let baslaButton = UIButton()
    let kenny = UIImageView()
    var zorlukSlider = UISlider()
    
    var tap = UIGestureRecognizer()
    
    var score = 0
    var countDown = 10
    var highscore = 0
    var kenyChangeLocationTimer = Timer()
    var countDownTimer = Timer();
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHighScore()
        uiInit()
        // Do any additional setup after loading the view.
    }
    
    func uiInit(){
        self.width = view.frame.width
        self.height = view.frame.height
       
        
        counterLabel.text = String(countDown)
        counterLabel.textAlignment = .center
        counterLabel.textColor = .orange
        counterLabel.font = UIFont(name: "Helvetica Neue", size: 60)
        counterLabel.frame = CGRect(x: width*0.5-40, y: height*0.01, width: 100, height: 100)
        
        view.addSubview(counterLabel)
        
        
        
        remainingLabel.text = "Saniye kaldı"
        remainingLabel.textAlignment = .center
        remainingLabel.textColor = .lightGray
        remainingLabel.frame = CGRect(x: width*0.5-50, y: height*0.12, width: 100, height: 50)
        
        view.addSubview(remainingLabel)
        
        
        
        scoreLabel.text = "Skor: \(score)"
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont(name: "Helvetica Neue", size: 40)
        scoreLabel.frame = CGRect(x: width*0.5-100, y: height*0.15, width: 200, height: 100)
        
        view.addSubview(scoreLabel)
        
        
        baslaButton.setTitle("Başla", for: .normal)
        baslaButton.backgroundColor = .purple
        baslaButton.isEnabled = true
        baslaButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        baslaButton.frame = CGRect(x: width*0.5-50, y: height*0.9, width: 100, height: 50)
       
        view.addSubview(baslaButton)
        
        kenny.image = UIImage(named: "kenny")
        kenny.frame = CGRect(x: width*0.1, y: height*0.3, width: width*0.2, height: width*0.25)
        
        view.addSubview(kenny)
        
        
        
        
        
        highScoreLabel.textAlignment = .center
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        highScoreLabel.frame = CGRect(x: width*0.5-100, y: height*0.78, width: 200, height: 50)
        
        view.addSubview(highScoreLabel)
        
        zorlukSlider.maximumValue = 1
        zorlukSlider.minimumValue = 0.1
        zorlukSlider.semanticContentAttribute = .forceRightToLeft
        zorlukSlider.value = 0.5
        zorlukSlider.minimumValueImage = UIImage(systemName: "plus")
        zorlukSlider.maximumValueImage = UIImage(systemName: "minus")
        zorlukSlider.frame = CGRect(x: width*0.5-100, y: height*0.82, width: 200, height: 50)
        
        view.addSubview(zorlukSlider)
    }
    
    @objc func startGame(){
        kenyTapDetector()
        
        
        self.score = 0
        self.countDown = 10
        
        self.scoreLabel.text = String(self.score)
        self.counterLabel.text = String(self.countDown)
        
        baslaButton.isHidden = true
        zorlukSlider.isHidden = true
        
        self.startTimers()
    }
   
     func startTimers(){
        //TO DO ZORLUK AYARI
        let zorluk = zorlukSlider.value
        kenyChangeLocationTimer = Timer.scheduledTimer(timeInterval: Double(zorluk), target: self, selector:#selector(pozisyonDegistir), userInfo:nil, repeats: true)
       countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownFunc), userInfo: nil, repeats: true
       )
    }
    func kenyTapDetector(){
        kenny.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(scoreArttir))
        kenny.addGestureRecognizer(tap)
    }
    @objc func scoreArttir(){
        score += 1
        scoreLabel.text = String(score)
    }
    
    @objc func countDownFunc(){
        countDown -= 1
        counterLabel.text = String(countDown)
        if countDown == 0{
            baslaButton.isHidden = false
            kenny.isUserInteractionEnabled = false
            zorlukSlider.isHidden = false
            
            countDownTimer.invalidate()
            kenyChangeLocationTimer.invalidate()
            
            defineHighScore()
            
            let alert = UIAlertController(
                title: "Zaman doldu", message: "Yeniden oynamak istermisiniz ? ", preferredStyle: UIAlertController.Style.alert)
            let hayirButton = UIAlertAction(title: "Hayır", style: UIAlertAction.Style.cancel, handler: nil)
            let evetButton = UIAlertAction(title: "Evet", style: UIAlertAction.Style.default) { UIAlertAction in
                
                self.startGame()
                
            }
            
            alert.addAction(evetButton)
            alert.addAction(hayirButton)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func pozisyonDegistir(){
        let randomXKatSayi = CGFloat.random(in: 0.1 ... 0.75)
        let randomYKatSayi = CGFloat.random(in: 0.3 ... 0.70)
        
        kenny.frame = CGRect(x: width*randomXKatSayi, y: height*randomYKatSayi, width: width*0.2, height: width*0.25)
        
    }
    func defineHighScore() {
        if self.score > self.highscore {
                       self.highscore = self.score
                       highScoreLabel.text = "Highscore: \(self.highscore)"
                       UserDefaults.standard.set(self.highscore, forKey: "highscore")
                   }
        
    }
    func checkHighScore() {
        let sonYuksekSkor = UserDefaults.standard.object(forKey: "highscore")
        
        if sonYuksekSkor == nil {
            highscore = 0
            highScoreLabel.text = "Highscore: \(highscore)"
        }
        
        if let yeniYuksekSkor = sonYuksekSkor as? Int {
            highscore = yeniYuksekSkor
            highScoreLabel.text = "Highscore: \(highscore)"
        }
    }
    
    


}


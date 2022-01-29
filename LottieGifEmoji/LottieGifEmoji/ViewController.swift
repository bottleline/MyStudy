//
//  ViewController.swift
//  LottieEmoji
//
//  Created by park kevin on 2022/01/28.
//

import UIKit
import Lottie
import Gifu

class ViewController: UIViewController {

    let textView:UITextView = UITextView()
    let lottieButton1 = UIButton()
    let lottieButton2 = UIButton()
    let gifButton1 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.translatesAutoresizingMaskIntoConstraints = false
        lottieButton1.translatesAutoresizingMaskIntoConstraints = false
        lottieButton2.translatesAutoresizingMaskIntoConstraints = false
        gifButton1.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        view.addSubview(gifButton1)
        view.addSubview(lottieButton1)
        view.addSubview(lottieButton2)
        
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.height/2).isActive = true
        textView.backgroundColor = .systemGray5
        
        lottieButton1.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: 30).isActive = true
        lottieButton1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lottieButton1.setTitle("add lottie 1", for: .normal)
        
        lottieButton2.topAnchor.constraint(equalTo: lottieButton1.bottomAnchor,constant: 30).isActive = true
        lottieButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lottieButton2.setTitle("add lottie 2", for: .normal)
        
        gifButton1.topAnchor.constraint(equalTo: lottieButton2.bottomAnchor,constant: 30).isActive = true
        gifButton1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gifButton1.setTitle("add gif", for: .normal)

        
        lottieButton1.addTarget(self, action: #selector(addLottie), for: .touchUpInside)
        lottieButton2.addTarget(self, action: #selector(addLottie2), for: .touchUpInside)
        gifButton1.addTarget(self, action: #selector(addGif), for: .touchUpInside)
        
        textView.delegate = self
    }
    

    
    @objc func addLottie(){
        let myTextAttachment = MyTextAttachment(attachType:.lottie,
                                                imageName: "heart",
                                                size: 30)
        attachAndSet(myTextAttachment)
    }
    
    @objc func addLottie2(){
        let myTextAttachment = MyTextAttachment(attachType:.lottie,
                                                imageName: "heart2",
                                                size: 30)
        attachAndSet(myTextAttachment)
    }
    
    @objc func addGif(){
        let myTextAttachment = MyTextAttachment(attachType:.gif,
                                                imageName: "bananadance",
                                                size: 30)
        attachAndSet(myTextAttachment)
    }
    
    func attachAndSet(_ myTextAttachment:MyTextAttachment){
        let text = NSMutableAttributedString(attributedString: textView.attributedText)
        text.append(NSAttributedString(attachment: myTextAttachment))
        textView.attributedText = text

        textView.setAnimationEmoji()
    }


}

extension ViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.textView.setAnimationEmoji()
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.textColor = .label
    }
}

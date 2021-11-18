//
//  VisionViewController.swift
//  ShoppingApp
//
//  Created by Syed Muhammad on 20/10/2021.
//

import UIKit
import Vision
enum ActionButton:String {
    case Start
    case Stop
}

class VisionViewController: UIViewController {
    
    var seconds:Int = 0
    let shapeLayer  = CAShapeLayer()
    var count = 0
    var timer : Timer?
    let layer = CAEmitterLayer()
    
    private let label:UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let button:UIButton = {
       let button  = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        createShapeLayerForTimer()
        view.addSubview(button)
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        label.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewSize:CGFloat = view.frame.width-60

        button.frame = CGRect(x: 60,
                              y: view.bottom - 200,
                              width: viewSize-60,
                              height: 50
        )
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
     
        
    }
     //MARK: - Selectors
    
    @objc func didTapButton(){
        layer.removeFromSuperlayer()
        let alert = UIAlertController(title: "Add", message: "Please enter seconds you want to Count Down", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Enter Seconds"
            textfield.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default){ [weak self] _ in
            guard let strongSelf = self else {return}
            guard let field = alert.textFields?.first ,
                  let text = field.text else {return}
            let animate = CABasicAnimation(keyPath: "strokeEnd")
            animate.fromValue = 0
            animate.toValue = 1
            animate.speed  = 1
            animate.duration = Double(text) ?? 10
            animate.timingFunction = CAMediaTimingFunction(name: .linear)
            self?.count = (Int(text) ?? 10)
            self?.label.text = "\(self!.count)"
            self?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: strongSelf, selector: #selector(self?.updateCounter), userInfo: nil, repeats: true)
            animate.isRemovedOnCompletion = false
            animate.fillMode  = .forwards
            self?.shapeLayer.add(animate, forKey: "animation")
        }
        )
        present(alert, animated: true, completion: nil)
    }
    // Sparkling
    private func createLayer() {
      
         layer.emitterPosition = CGPoint(
             x: view.center.x,
             y: -100
         )

         let colors: [UIColor] = [
             .systemRed,
             .systemBlue,
             .systemOrange,
             .systemGreen,
             .systemPink,
             .systemYellow,
             .systemPurple
         ]

         let cells: [CAEmitterCell] = colors.compactMap {
             let cell = CAEmitterCell()
             cell.scale = 0.05
             cell.emissionRange = .pi * 2
             cell.lifetime = 10
             cell.birthRate = 50
             cell.velocity = 150
             cell.color = $0.cgColor
             cell.contents = UIImage(named: "DotImage")!.cgImage
             return cell
         }

         layer.emitterCells = cells

         view.layer.addSublayer(layer)
     }
   
    
    // shape Layer
    
    fileprivate func createShapeLayerForTimer() {
        let boarderPath = UIBezierPath(arcCenter: view.center,
                                       radius: 110, startAngle: -(.pi/2),
                                       endAngle: (3 * .pi)/2,
                                       clockwise: true)
        
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = boarderPath.cgPath
        borderLayer.lineWidth = 40
        borderLayer.strokeColor = UIColor.customRedBackground.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(borderLayer)
        
        let pulseAnimation = CABasicAnimation(keyPath:"lineWidth")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 40
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        borderLayer.add(pulseAnimation, forKey: "animateOpacity")
        
        let circlePath = UIBezierPath(arcCenter: view.center,
                                      radius: 100, startAngle: -(.pi/2),
                                      endAngle: (3 * .pi)/2,
                                      clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = circlePath.cgPath
        trackLayer.lineWidth = 20
        trackLayer.strokeColor = UIColor.customRed.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.backgroundColor = UIColor.customRedMain.cgColor
        shapeLayer.strokeColor = UIColor.customRedMain.cgColor
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc func updateCounter(){
        if(count > 0) {
            count -= 1
            print("Timer count \(count)")
            label.text = "\(count)"
            if count == 0 {
                createLayer()
            }
        }else {
            
            timer?.invalidate()
            
        }
    }
}


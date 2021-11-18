//
//  ViewController.swift
//  ShoppingApp
//
//  Created by syed on 09/10/2021.
//

import UIKit


class HomeViewController: UIViewController {
    
    var carColor : UIColor?
    var defaultHue: Float = 359 //default color of blue truck
      var hueRange: Float = 60
    var ciImage: CIImage?
    var imagePickerController = UIImagePickerController()
    
    private let switchWhite:UISwitch = {
       let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        return switch1
        
    }()
    private let imageViewColorBar:UIImageView = {
       let imageView = UIImageView()
        
        return imageView
    }()
    private let labelHue:UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let mainImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Car4")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let slider:UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private let button : UIButton = {
       let button = UIButton()
        button.setTitle("Change Color", for: .normal)
        button.addTarget(self, action: #selector(didTapColorPicker), for: .touchUpInside)
        button.tintColor  = .label
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(mainImageView)
        ciImage = CIImage(image: mainImageView.image!)
        view.addSubview(button)
        view.addSubview(slider)
        view.addSubview(switchWhite)
        view.addSubview(imageViewColorBar)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        imageViewColorBar.image = UIImage(named: "hueScale")
        ciImage = CIImage(image: mainImageView.image!)
        carColor = mainImageView.image?.averageColor
        getColorFromCar()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(gesture)
        
    }
    @objc func didTap(_ gesture:UITapGestureRecognizer){
        let point = gesture.location(in: gesture.view)
        let color = mainImageView.image?.getPixelColor(pos: point)
        view.backgroundColor = color
    }
    private func getColorFromCar(){
        if let carColor = mainImageView.image?.areaAverage(){
            let hue = RGBtoH(Float(carColor.redValue), g: Float(carColor.greenValue), b: Float(carColor.blueValue))
            defaultHue = hue*360
            slider.value = hue
            print(defaultHue)
        }
        render()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewSize:CGFloat = view.frame.width-60
        mainImageView.frame = CGRect(x: 30,
                                y: (view.frame.height-viewSize)/2-50,
                                width: viewSize,
                                height: viewSize-60
        )
       
        slider.frame = CGRect(x: 30,
                              y: mainImageView.bottom,
                              width: viewSize,
                              height:  60)
        
        imageViewColorBar.frame = CGRect(x: 30,
                                         y: slider.bottom,
                                         width: viewSize,
                                         height: 60)
        switchWhite.frame = CGRect(x: imageViewColorBar.right-80,
                                   y:imageViewColorBar.bottom+30 ,
                                   width: 40,
                                   height: 40)
        button.frame = CGRect(x: imageViewColorBar.left, y:switchWhite.bottom, width: viewSize, height: 50)
       
        
    }
    @objc func didTapAddButton(_ sender: UIBarButtonItem){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePickerController.delegate = self
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.allowsEditing  = false
            present(imagePickerController, animated: true)
            
        }
        
        
    }
    @objc func sliderChanged(_ sender: AnyObject) {
        if carColor == nil {
            print("Show alert here")
        }else {
            DispatchQueue.main.async {
                self.render()
            }
        }
      
   
    }
    
    @objc func didSwitch(_ switchWhite:UISwitch){
        if switchWhite.isOn {
            imageViewColorBar.image = UIImage(named: "grayScale")
        } else {
            imageViewColorBar.image = UIImage(named: "hueScale")
        }
        render()
        
    }
    @objc func didTapColorPicker(){
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    func render() {
        let centerHueAngle: Float = defaultHue/360.0
        var destCenterHueAngle: Float = slider.value
        let minHueAngle: Float = (defaultHue - hueRange/2.0) / 360
        let maxHueAngle: Float = (defaultHue + hueRange/2.0) / 360
        let hueAdjustment = centerHueAngle - destCenterHueAngle
        if destCenterHueAngle == 0 && !switchWhite.isOn {
            destCenterHueAngle = 1 //force red if slider angle is 0
        }
        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0, 0, 0]
        var hsv: (h : Float, s : Float, v : Float)
        var newRGB: (r : Float, g : Float, b : Float)
        var offset = 0
        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {
                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(rgb[0], g: rgb[1], b: rgb[2])
                    if hsv.h < minHueAngle || hsv.h > maxHueAngle {
                        newRGB.r = rgb[0]
                        newRGB.g = rgb[1]
                        newRGB.b = rgb[2]
                    } else {
                        if switchWhite.isOn {
                            hsv.s = 0
                            hsv.v = hsv.v - hueAdjustment
                        } else {
                            hsv.h = destCenterHueAngle == 1 ? 0 : hsv.h - hueAdjustment //force red if slider angle is 360
                        }
                        newRGB = HSVtoRGB(hsv.h, s:hsv.s, v:hsv.v)
                    }
                    cubeData[offset] = newRGB.r
                    cubeData[offset+1] = newRGB.g
                    cubeData[offset+2] = newRGB.b
                    cubeData[offset+3] = 1.0
                    offset += 4
                }
            }
        }
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as NSData
        let colorCube = CIFilter(name: "CIColorCube")!
        colorCube.setValue(size, forKey: "inputCubeDimension")
        colorCube.setValue(data, forKey: "inputCubeData")
        colorCube.setValue(ciImage, forKey: kCIInputImageKey)
        if let outImage = colorCube.outputImage {
            let context = CIContext(options: nil)
            let outputImageRef = context.createCGImage(outImage, from: outImage.extent)
            mainImageView.image = UIImage(cgImage: outputImageRef!)
        }
    }
    func HSVtoRGB(_ h : Float, s : Float, v : Float) -> (r : Float, g : Float, b : Float) {
        var r : Float = 0
        var g : Float = 0
        var b : Float = 0
        let C = s * v
        let HS = h * 6.0
        let X = C * (1.0 - fabsf(fmodf(HS, 2.0) - 1.0))
        if (HS >= 0 && HS < 1) {
            r = C
            g = X
            b = 0
        } else if (HS >= 1 && HS < 2) {
            r = X
            g = C
            b = 0
        } else if (HS >= 2 && HS < 3) {
            r = 0
            g = C
            b = X
        } else if (HS >= 3 && HS < 4) {
            r = 0
            g = X
            b = C
        } else if (HS >= 4 && HS < 5) {
            r = X
            g = 0
            b = C
        } else if (HS >= 5 && HS < 6) {
            r = C
            g = 0
            b = X
        }
        let m = v - C
        r += m
        g += m
        b += m
        return (r, g, b)
    }
    
    
    func RGBtoHSV(_ r : Float, g : Float, b : Float) -> (h : Float, s : Float, v : Float) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return (Float(h), Float(s), Float(v))
    }
    
    func RGBtoH(_ r : Float, g : Float, b : Float) -> Float {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return Float(h)
    }

}
extension HomeViewController:UIColorPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  
   func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {

           let hue = RGBtoH(Float(color.redValue), g: Float(color.greenValue), b: Float(color.blueValue))
           defaultHue = hue*360
           slider.value = hue
           print(defaultHue)
      // render()
       
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
                  fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
              }
        
        mainImageView.image = image
        ciImage = CIImage(image: mainImageView.image!)
        getColorFromCar()
        slider.value = 0
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}


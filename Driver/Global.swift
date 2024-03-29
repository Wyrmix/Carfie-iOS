//
//  Global.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import AccountKit
import AudioToolbox
import PopupDialog
import UIKit

var currentBundle : Bundle!

var pulsatingLayer  = CAShapeLayer()
var shapeLayer: CAShapeLayer!

var animationGroup = CAAnimationGroup()

var initialPulseScale:Float = 0
var nextPulseAfter:TimeInterval = 0
var animationDuration:TimeInterval = 1.5
var radius:CGFloat = 200
var numberOfPulses:Float = Float.infinity
var selectedLanguage : Language = .english

//MARK:- Show Alert
internal func showAlert(message : String?, handler : ((UIAlertAction) -> Void)? = nil)->UIAlertController{
    
    let alert = UIAlertController(title: AppName, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:  Constants.string.OK, style: .default, handler: handler))
    alert.view.tintColor = .primary
    return alert
}

//MARK:- Show Alert With Action

func showAlert(message : String?, okHandler : ((Bool)->Void)?, fromView : UIViewController, isShowCancel : Bool = false, okTitle : String = Constants.string.OK,cancelTitle : String = Constants.string.Cancel){
    let alert = PopupDialog(title: message, message: nil)
    let okButton =  PopupDialogButton(title: okTitle.localize(), action: {
        okHandler?(true)
        alert.dismiss()
    })
    alert.transitionStyle = .zoomIn
    alert.addButton(okButton)
    
    if isShowCancel {
        let cancelButton =  PopupDialogButton(title: cancelTitle.localize(), action: {
            okHandler?(false)
            alert.dismiss()
        })
        alert.addButton(cancelButton)
    }
    fromView.present(alert, animated: true, completion: nil)
}

//MARK:- ShowLoader

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.primary.cgColor
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.style = .whiteLarge
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    uiView.addSubview(container)
    actInd.startAnimating()
    
    return container
    
}




internal func storeInUserDefaults(){
    
    let data = NSKeyedArchiver.archivedData(withRootObject: User.main)
    UserDefaults.standard.set(data, forKey: Keys.list.userData)
    //UserDefaults.standard.set(data, forKey: Keys.list.accessToken)
    UserDefaults.standard.set(User.main.firstName, forKey: Keys.list.firstName)
    UserDefaults.standard.set(User.main.lastName, forKey: Keys.list.lastName)
    UserDefaults.standard.set(User.main.currency, forKey: Keys.list.currency)
    UserDefaults.standard.set(User.main.serviceType, forKey: Keys.list.serviceType)
    _ = UserDefaults.standard.set(User.main.picture, forKey: Keys.list.picture)
    UserDefaults.standard.synchronize()
    
    
    print("Store in UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Failed")
}

// Retrieve from UserDefaults
func retrieveUserData() -> Bool{
    
    if let firstName = UserDefaults.standard.value(forKey: Keys.list.name) {
        User.main.firstName = firstName as? String
    }
    if let lastname = UserDefaults.standard.value(forKey: Keys.list.lastName){
        User.main.lastName = lastname as? String
    }
    if let picture = UserDefaults.standard.value(forKey: Keys.list.picture){
        User.main.picture = picture as? String
    }
    if let currency = UserDefaults.standard.value(forKey: Keys.list.currency){
        User.main.currency = currency as? String
    }
    
    if let data = UserDefaults.standard.object(forKey: Keys.list.userData) as? Data, let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
        
        User.main = userData

        // Editing auth internal state from a global data layer function is not ideal, but will live on for now
        // until this tech debt can be addressed.
        DefaultAuthController.shared(.driver).getAccessToken(completion: nil)
        if let loginType = userData.loginType, let authProvider = AuthProviderType(rawValue: loginType) {
            DefaultAuthController.shared(.driver).currentAuthProviderType = authProvider
        }
        
        return true
    }
    
    return false
}

// Clear UserDefaults
internal func clearUserDefaults(){
    
    User.main = initializeUserData()  // Clear local User Data
    UserDefaults.standard.set(nil, forKey: Keys.list.userData)
    UserDefaults.standard.set(nil, forKey: Keys.list.accessToken)
    UserDefaults.standard.set(nil, forKey: Keys.list.email)
    UserDefaults.standard.set(nil, forKey: Keys.list.firstName)
    UserDefaults.standard.set(nil, forKey: Keys.list.lastName)
    UserDefaults.standard.set(nil, forKey: Keys.list.picture)
    UserDefaults.standard.set(nil, forKey: Keys.list.currency)
    UserDefaults.standard.set(nil, forKey: Keys.list.id)
    UserDefaults.standard.removeVolatileDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    
    print("Clear UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Success")
    
}

func toastSuccess(_ view:UIView,message:NSString,smallFont:Bool,isPhoneX:Bool, color:UIColor){
    var labelView = UIView()
    labelView.showAnimateView(labelView, isShow: true, direction: .Top)
    if(isPhoneX){
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 80))
    }else{
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 60))
    }
    labelView.backgroundColor = color
    
    //UIColor(red: 35/255, green: 86/255, blue: 142/255, alpha: 1)
    
    
    let  toastLabel = UILabel(frame: CGRect(x: 0,y:(labelView.frame.size.height/2),width:view.frame.size.width, height: labelView.frame.size.height/2))
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center
    toastLabel.numberOfLines = 2
    if(smallFont){
        // toastLabel.font = UIFont.boldSystemFont(ofSize: 10)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
    }else{
        // toastLabel.font = toastLabel.font.withSize(14)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
    }
    
    labelView.addSubview(toastLabel)
    view.addSubview(labelView)
    toastLabel.text = message as String
    labelView.alpha = 1.0
    let deadlineTime = DispatchTime.now() + .seconds(2)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        labelView.alpha = 0.0
        labelView.showAnimateView(labelView, isShow: false, direction: .Bottom)
        labelView.removeFromSuperview()
    }
}


func forceLogout(with message : String? = nil) {
    DefaultAuthController.shared(.driver).logout()
    AKFAccountKit(responseType: .accessToken).logOut()
    AVPlayerHelper.player.stop()
    BackGroundTask.backGroundInstance.stopBackGroundTimer() // stopping timer on unauthorized status
    BackGroundTask.refresh()
    clearUserDefaults()
    if message != nil {
        UIApplication.shared.windows.last?.rootViewController?.view.makeToast(message, duration: 2, position: .center, title: nil, image: nil, style: ToastStyle(), completion: nil)
    }
}

// Initialize User

internal func initializeUserData()->User
{
    return User()
}


func setLocalization(language : Language){
    
    if let path = Bundle.main.path(forResource: language.code, ofType: "lproj"), let bundle = Bundle(path: path) {
        let attribute : UISemanticContentAttribute = language == .arabic ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        selectedLanguage = language
        currentBundle = bundle
    } else {
        currentBundle = .main
    }
    
}


//MARK:- set circle animation for request screen
//MAK:- set Circle Animation Used in Earnings ViewController
func setCircleAnimation(view: UIView, toVlaue : Float)-> CAShapeLayer{
    let shapeLayer = CAShapeLayer()
    
    let center = view.center
    
    // create my track layer
    let trackLayer = CAShapeLayer()
    
    let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
    trackLayer.path = circularPath.cgPath
    
    trackLayer.strokeColor = UIColor.rgb(r: 248, g: 248, b: 248).cgColor
    trackLayer.lineWidth = 10
    view.layer.addSublayer(trackLayer)
    shapeLayer.path = circularPath.cgPath
    
    shapeLayer.strokeColor = UIColor.primary.cgColor
    shapeLayer.lineWidth = 10
    shapeLayer.fillColor = UIColor.white.cgColor
    shapeLayer.lineCap = .round
    
    shapeLayer.strokeEnd = 0
    
    view.layer.addSublayer(shapeLayer)

    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = toVlaue
    basicAnimation.fromValue = 0
    basicAnimation.duration = 2
    //basicAnimation.repeatCount = 1
   // basicAnimation.repeatDuration = 1000
    
    basicAnimation.fillMode = .forwards
    basicAnimation.isRemovedOnCompletion = false
    
    shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    
    return trackLayer
}

//MARK:- add blur effect to UIview

func addBlurEffectToView(view: UIView, blurEffect: UIBlurEffect.Style, backGroundColor: UIColor){
    
    let blurView = UIBlurEffect(style: blurEffect)
    let visualEffectView = UIVisualEffectView(effect: blurView)
    visualEffectView.frame = view.bounds
    visualEffectView.backgroundColor = backGroundColor
    
}



private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, view: UIView) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: CGFloat.pi / 2 * 2, endAngle: 0 , clockwise: true)
    layer.path = circularPath.cgPath
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = 5
    layer.fillColor = fillColor.cgColor
    //layer.lineCap = kCALineCapSquare
    layer.lineJoin = .round
    layer.position = CGPoint(x: view.frame.width/2, y: view.frame.height)

    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = 1
    basicAnimation.fromValue = 0
    basicAnimation.duration = 60
    basicAnimation.fillMode = .forwards
    basicAnimation.isRemovedOnCompletion = false
    layer.add(basicAnimation, forKey: "basicEnd")
    
    return layer
}


 func setupCircleLayers(view: UIView) ->CAShapeLayer{
    
    pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.primary, view: view)
    
    view.layer.addSublayer(pulsatingLayer)
    _ = animatePulsatingLayer()
    
    let trackLayer = createCircleShapeLayer(strokeColor: .secondary, fillColor: .backgroundColor, view: view) //STroke color
    view.layer.addSublayer(trackLayer)
    
    shapeLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear, view: view)
    
    shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
    shapeLayer.strokeEnd = 0
    return shapeLayer
}

 func animatePulsatingLayer()-> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    
    animation.toValue = 1.5
    animation.duration = animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.autoreverses = false
    animation.repeatCount = .infinity
    
    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.duration = animationDuration
    opacityAnimation.values = [0.4, 0.8, 0]
    opacityAnimation.keyTimes = [0, 0.2, 1]
    let time : TimeInterval = 60
    let warn : TimeInterval = 20
    let deadLine : TimeInterval = 10
    opacityAnimation.repeatDuration = 10000
        
        DispatchQueue.main.asyncAfter(deadline: (.now()+time)-deadLine, execute: {
            pulsatingLayer.fillColor = UIColor.red.cgColor
            pulsatingLayer.fillColor?.copy(alpha: 0.5)
        })
    
    DispatchQueue.main.asyncAfter(deadline: (.now()+time)-warn, execute: {
        pulsatingLayer.fillColor = UIColor.yellow.cgColor
    })
    
    pulsatingLayer.add(animation, forKey: "pulsing")
    pulsatingLayer.add(opacityAnimation, forKey: "opacity")
    
    return animation
}

//Shadow View:
func shadowApply(view:UIView) -> UIView{
    
    let shadowSize : CGFloat = 0.3
    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2, y: -shadowSize / 2, width: view.frame.size.width + shadowSize, height: view.frame.size.height + shadowSize))
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowOpacity = 0.5
    view.layer.shadowPath = shadowPath.cgPath
    return view
}


func createOpacityAnimation() -> CAKeyframeAnimation {
    
    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.duration = animationDuration
    opacityAnimation.values = [0.4, 0.8, 0]
    opacityAnimation.keyTimes = [0, 0.2, 1]
    
    
    return opacityAnimation
}

func setFont(TextField : UITextField?, label : UILabel?, Button: UIButton?, size: CGFloat?, with Title: Bool = false) {
    switch (TextField ,label, Button) {
    case ( _,  _,  _) where TextField != nil :
        TextField?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        if size != nil {
            TextField?.font = UIFont(name: FontCustom.medium.rawValue, size: size!)
        }
        if Title {
            TextField?.font = UIFont(name: FontCustom.bold.rawValue, size: size ?? 16)
        }
        if [NSTextAlignment.left, .right].contains(TextField!.textAlignment) {
            (TextField)?.textAlignment = (selectedLanguage == .arabic) ? .right : .left
        }
    case ( _,  _,  _) where  label != nil:
        label?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        if size != nil {
            label?.font = UIFont(name: FontCustom.medium.rawValue, size: size! )
        }
        if Title {
            label?.font = UIFont(name: FontCustom.bold.rawValue, size: size ?? 16)
        }
        if [NSTextAlignment.left, .right].contains(label!.textAlignment) {
            (label)?.textAlignment = (selectedLanguage == .arabic) ? .right : .left
        }
        
    case ( _,  _,  _) where Button != nil:
        Button?.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        if size != nil {
            Button?.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: size ?? 16)
        }
        if Title {
             Button?.titleLabel?.font = UIFont(name: FontCustom.bold.rawValue, size: size ?? 16)
        }
        
    default:
        print("default")
    }
}

func converteMinToSec(Min: Int)-> (Int){
    return (Min * 60)
}

func convertMinToHour(minutes : Int) -> (Int) {
    return (minutes * 3600)
}

func vibrate(sound: defaultSystemSound) {
    AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(sound.rawValue), nil)
}

func makeCall(phoneNumber: String? ){
    if let providerNumber = phoneNumber, let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIScreen.main.focusedView?.make(toast: Constants.string.cannotMakeCallAtThisMoment.localize())
    }
}

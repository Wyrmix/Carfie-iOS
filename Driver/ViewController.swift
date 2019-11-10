
import UIKit
import Foundation

fileprivate var bottomConstraint : NSLayoutConstraint?
fileprivate var imageCompletion : ((UIImage?)->())?
fileprivate var constraintValue : CGFloat = 0

extension UIViewController {
    
    func setPresenter(){
        
        if let view = self as? PostViewProtocol {
            
            view.presenter = presenterObject
            view.presenter?.controller = view
            presenterObject = view.presenter
            
        }
        
    }
    
    //MARK:- Present
    
    func present(id : String, animation : Bool, from storyboard : UIStoryboard = Router.main){
        
         let vc = storyboard.instantiateViewController(withIdentifier: id)
         self.present(vc, animated: animation, completion: nil)
        
        
    }
    
    //MARK:- Push
    
    func push(id : String, animation : Bool, from storyboard : UIStoryboard = Router.main){
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc, animated: animation)
        
        
    }
    
    //MARK:- Push To Right
    
    func pushRight(toViewController viewController : UIViewController){
        
        self.makePush(transition: CATransitionSubtype.fromLeft.rawValue)
        navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    private func makePush(transition type : String){
        
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype(rawValue: type)
        //transition.delegate = self
        navigationController?.view.layer.add(transition, forKey: nil)
        //navigationController?.isNavigationBarHidden = false
        
    }
    
    func popLeft() {
        
        self.makePush(transition: CATransitionSubtype.fromRight.rawValue)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK:- Add observers
    
    func addKeyBoardObserver(with constraint : NSLayoutConstraint){
        
        bottomConstraint = constraint
        
        constraintValue = constraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(info:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(info:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(info:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    //MARK:- Keyboard will show
    
    @IBAction private func keyboardWillShow(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        bottomConstraint?.constant = -(keyboard.height)
        self.view.layoutIfNeeded()
    }
    
    
    //MARK:- Keyboard will hide
    
    @IBAction private func keyboardWillHide(info : NSNotification){
        
        bottomConstraint?.constant = constraintValue
        self.view.layoutIfNeeded()
        
    }
    
    
    //MARK:- Back Button Action
    
    @IBAction func backButtonClick() {
        //BackGroundTask.backGroundInstance.detailviewStatus = false
        self.popOrDismiss(animation: true)
        
    }
    
    
    
    //MARK:- Show Image Selection Action Sheet
    
    func showImage(with completion : @escaping ((UIImage?)->())){
        
        let alert = UIAlertController(title: Constants.string.selectSource.localize(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.string.camera.localize(), style: .default, handler: { (Void) in
            self.chooseImage(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.photoLibrary.localize(), style: .default, handler: { (Void) in
            self.chooseImage(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler:nil))
        alert.view.tintColor = .primary
        imageCompletion = completion
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Show Image Picker
    
    private func chooseImage(with source : UIImagePickerController.SourceType) {}
    
    
    /*  //MARK:- Right Bar Button Action
     
     @IBAction private func rightBarButtonAction(){
     
     let alertRightBar = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
     
     alertRightBar.addAction(UIAlertAction(title: Constants.string.newGroup, style: .default, handler: { (Void) in
     
     }))
     
     alertRightBar.addAction(UIAlertAction(title: Constants.string.newBroadcast, style: .default, handler: { (Void) in
     
     }))
     
     alertRightBar.addAction(UIAlertAction(title: Constants.string.starredMessages, style: .default, handler: { (Void) in
     
     }))
     
     alertRightBar.addAction(UIAlertAction(title: Constants.string.settings, style: .default, handler: { (Void) in
     
     self.pushRight(toViewController: self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.SettingViewController))
     
     }))
     
     alertRightBar.addAction(UIAlertAction(title: Constants.string.Cancel, style: .cancel, handler: { (Void) in
     
     }))
     
     alertRightBar.view.tintColor = .primary
     
     self.present(alertRightBar, animated: true, completion: nil)
     
     }  */
    
    
    //MARK:- Show Search Bar with self delegation
    
    @IBAction private func showSearchBar(){
        
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.delegate = self as? UISearchBarDelegate
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        searchBar.searchBar.tintColor = .primary
        self.present(searchBar, animated: true, completion: nil)
        
    }
    
    
    
}

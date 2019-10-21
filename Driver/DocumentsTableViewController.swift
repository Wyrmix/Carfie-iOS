//
//  DocumentsTableViewController.swift
//  Provider
//
//  Created by CSS on 24/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import QuickLook

class DocumentsTableViewController: UITableViewController {

    private var datasource = [DocumentsModel]()
    private lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow!)
    }()
    
    private var modifiedDocuments = [Int:(image : UIImage, data : Data)]() {   // Upload Document only if the documents been modified or added
        didSet{
            let count = self.datasource.reduce(into: 0, { (res, model) in
                   var value = 0
                    if model.providerdocuments != nil {
                       value += 1
                    } else if let id = model.id, modifiedDocuments.contains(where: { $0.key == id }) {
                       value += 1
                    }
                    res = res+value
                })
            self.navigationItem.rightBarButtonItem?.isEnabled = (count==datasource.count)
        }
    }
    
    var isGettingDocuments = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiallLoads()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layouts()
    }
    
}

// MARK:- Methods
extension DocumentsTableViewController {
    
    private func initiallLoads() {
        self.tableView.register(UINib(nibName: XIB.Names.DocumentsTableViewCell, bundle: nil), forCellReuseIdentifier:  XIB.Names.DocumentsTableViewCell)
        self.presenter?.get(api: .getDocuments, parameters: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.upload.localize(), style: .done, target: self, action: #selector(self.barButtonUploadAction))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.title = Constants.string.documents.localize()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backBarButtonAction))
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
            
    }
    
    private func layouts() {
        
    }
    
    @IBAction private func barButtonUploadAction() {
        var idValue = [String : Int]()
        var documentValue = [String : Data]()
        for (index,document) in self.modifiedDocuments.enumerated() {
            idValue.updateValue(document.key, forKey: "id[\(index)]")
            documentValue.updateValue(document.value.data, forKey: "document[\(index)]")
        }
        self.loader.isHidden = false
        self.presenter?.post(api: .uploadDocuments, imageData: documentValue, parameters: idValue)
    }
    
    // MARK:- Back Button Action
    
    @IBAction private func backBarButtonAction() {
        if isGettingDocuments {
             self.logout()
        } else {
            self.popOrDismiss(animation: true)
        }
    }
    
    // MARK:- Logout Action
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            self.loader.isHidden = true
            self.presenter?.post(api: .logout, data: nil)
        }
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.view.tintColor = .primary
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- Tableview Datasource & Tableview Delegate
extension DocumentsTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if let tableCell = tableView.dequeueReusableCell(withIdentifier:  XIB.Names.DocumentsTableViewCell, for: indexPath) as? DocumentsTableViewCell {
            if self.datasource.count > indexPath.section {
                tableCell.set(values: self.datasource[indexPath.section], modifiedDocuments: self.modifiedDocuments)
                tableCell.onclickAdd = { [weak self] documentId, completion in
                    guard let self = self else { return }
                    self.showImage(with: { (image) in
                        
                        var imageObject = image
                        if imageObject != nil, var imageData = imageObject!.pngData() {
                            var size = Double(imageData.count)/1024
                            while size>2048{
                                
                                if let imageResized = imageObject?.resize(with: 0.9),let imageObjectData = imageResized.pngData() {
                                    imageObject = imageResized
                                    imageData = imageObjectData
                                    size = Double(imageObjectData.count)/1024
                                } else {
                                    break
                                }
                            }
                            
                            self.modifiedDocuments.updateValue((image: image!, data: imageData), forKey: documentId)
                        }
                        completion(image)
                    })
                }
            }
            return tableCell
        }
        
      return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.datasource.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.datasource[section].name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        if self.datasource.count>indexPath.section,
//          // let docId = self.datasource[indexPath.section].id,
//           //let imageObject = self.modifiedDocuments[docId]{
//           //let quickLookVc = QLPreviewController()
//         //  quickLookVc.dataSource
//        }
        
    }
    
}


extension DocumentsTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHideInMainThread(true)
        UIApplication.shared.keyWindow?.makeToast(message)
    }
    
    func getDocumentsEntity(api: Base, data: DocumentsEntity?) {
        self.loader.isHideInMainThread(true)
        self.datasource = data?.documents ?? []
        self.tableView.reloadInMainThread()
        
        if api == .uploadDocuments {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.make(toast: Constants.string.documentsUploadedSuccessfully.localize(), duration: 1, completion: {
                    if !self.isGettingDocuments {
                        self.navigationController?.popToRootViewController(animated: true)
//                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AddCardViewController) as? AddCardViewController {
//                            vc.isGettingDocuments = true
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
                    }
//                    else {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
                })
            }
        }
        
    }
    
    func getSucessMessage(api: Base, data: String?) {
        if api == .logout {
            forceLogout(with: data)
        }
    }
 
//    private func updateDocumentsAndResizeImage(_ image: UIImage) {
//        guard var imageData = image.pngData() else { return }
//        var size = Double(imageData.count) / 1024
//        while size > 2048 {
//            guard let imageResized = image.resize(with: 0.9), let imageObjectData = imageResized.pngData() else { return }
//            imageData = imageObjectData
//            size = Double(imageObjectData.count)/1024
//        }
//        
//        modifiedDocuments.updateValue((image: imageResized, data: imageData), forKey: documentId)
//    }
}

//extension DocumentsTableViewController: UIImagePickerControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true) {
//            guard let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage else { return }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//}

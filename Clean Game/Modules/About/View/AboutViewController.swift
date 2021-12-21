//
//  AboutViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var userImage: RoundImageView!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profil"
        navigationSetup()
        loadProfile()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker(_:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Properties
    var presenter: ViewToPresenterAboutProtocol?
    private var imagePicker: ImagePicker!
    private var imageString: String = ""
}

extension AboutViewController {
    
    private func setupUI() {
    }
    
    private func loadProfile(){
        ProfileModel.synchronize()
        self.userNameField.text = ProfileModel.userName
        self.userEmailField.text = ProfileModel.userEmail
        if let decodedData = Data(base64Encoded: ProfileModel.userImage , options: .ignoreUnknownCharacters) {
            var image = UIImage()
            if decodedData.isEmpty {
                image = UIImage(systemName: "person.circle.fill") ?? UIImage()
            } else {
                image = UIImage(data: decodedData) ?? UIImage()
            }
            self.userImage.image = image
            self.userImage.makeRounded()
        }
    }
    
    private func navigationSetup(){
        let saveButton = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action:  #selector(self.saveProfile))
        self.navigationItem.rightBarButtonItem  = saveButton
    }
    
    @objc private func saveProfile(){
        if let username = userNameField.text, let email = userEmailField.text {
            if username.isEmpty {
                showMessage(of: .warning, title: "Peringatan", subtitle: "Nama harus diisi")
            } else if email.isEmpty {
                showMessage(of: .warning, title: "Peringatan", subtitle: "Email harus diisi")
            } else if imageString.isEmpty {
                showMessage(of: .warning, title: "Peringatan", subtitle: "Foto harus diisi")
            } else {
                saveUserInfo(username, email, imageString)
                dismiss(animated: true)
                showMessage(of: .success, title: "Berhasil", subtitle: "profile berhasil diubah")
            }
        }
    }
    
    @objc private func showImagePicker(_ sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
    
    private func saveUserInfo(_ name: String, _ email: String, _ image: String){
        ProfileModel.userName = name
        ProfileModel.userEmail = email
        ProfileModel.userImage = image
    }
    
    func textEmpty(_ field: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: "\(field) is empty",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AboutViewController: PresenterToViewAboutProtocol {}

extension AboutViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.userImage.image = image
        self.userImage.makeRounded()
        self.imageString = image?.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}


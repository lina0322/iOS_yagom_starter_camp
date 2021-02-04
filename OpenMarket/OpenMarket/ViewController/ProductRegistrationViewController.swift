//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
// TODO: 등록완료 후 데이터 리로드... info.plist

import UIKit

final class ProductRegistrationViewController: UIViewController {
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var titleField: UITextField!
    @IBOutlet private var currencyField: UITextField!
    @IBOutlet private var priceField: UITextField!
    @IBOutlet private var originalPriceField: UITextField!
    @IBOutlet private var stockField: UITextField!
    @IBOutlet private var descriptionView: UITextView!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var imageCountLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet weak var registrationButton: UIBarButtonItem!
    private let cancelButton = UIButton()
    var navigationTitle = String.empty
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configureNavigatinbar()
        configureKeyboardDoneButton()
        setUpPasswordSecure()
        registrationButton.isEnabled = false
        descriptionView.delegate = self
        checkTextFields()
    }
    
    private func checkTextFields() {
        [titleField, currencyField, priceField, stockField, passwordField].forEach {
            $0.addTarget(self, action: #selector(checkAllRequirementsAreFilled), for: .editingChanged)
        }
    }
    
    @objc private func checkAllRequirementsAreFilled() {
        guard let title = titleField.text, !title.isEmpty,
              let currency = currencyField.text, !currency.isEmpty,
              let price = priceField.text, !price.isEmpty,
              let stock = stockField.text, !stock.isEmpty,
              let description = descriptionView.text, !description.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            registrationButton.isEnabled = false
            return
        }
        registrationButton.isEnabled = true
    }
    
    @IBAction func touchUpRegistrationButton() {
        postProduct()
        showSuccessAlert(about: "게시글 등록 성공")
    }
    
    func showSuccessAlert(about message: String) {
        let alert = UIAlertController(title: message, message: String.empty, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpAddImageButton() {
        showImagePickerActionSheet()
    }
    
    private func setUpPasswordSecure() {
        passwordField.isSecureTextEntry = true
    }
    
    // MARK: - Keyboard 관련
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height + 150, right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    private func configureKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton))
        
        toolBarKeyboard.items = [flexibleSpace, doneButton]
        descriptionView.inputAccessoryView = toolBarKeyboard
        for textField in textFields {
            textField.inputAccessoryView = toolBarKeyboard
        }
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    // MARK: - NavigationBar
    private func configureNavigatinbar() {
        configureCancelButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.title = navigationTitle
    }
    
    private func configureCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UPload to server
extension ProductRegistrationViewController {
    func postProduct() {
        guard let title = titleField.text, let currency = currencyField.text, let priceText = priceField.text, var price = Int(priceText), let stockText = stockField.text, let stock = Int(stockText), let description = descriptionView.text, let password = passwordField.text else {
            return
        }
        var discountedPrice: Int? = nil
        if let originalPriceText = originalPriceField.text, let originalPrice = Int(originalPriceText) {
            discountedPrice = price
            price = originalPrice
        }

        let imageData = UIImage(systemName: "house")!.withTintColor(.lightGray).pngData()!
        let product = Product(forPostPassword: password,
                              title: title,
                              descriptions: description,
                              price: price,
                              currency: currency,
                              stock: stock,
                              discountedPrice: discountedPrice,
                              imageFiles: [imageData]
        )
        
        Uploader.uploadData(by: .post, product: product, apiRequestType: .postProduct) { result in
            switch result {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                self.showErrorAlert(about: error.localizedDescription)
            }
        }
    }

}

// MARK: - ImagePicker
extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func showImagePickerActionSheet() {
        view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumButton = UIAlertAction(title: "앨범에서 선택하기", style: .default) { _ in
            self.openAlbum()
        }
        let cameraButton = UIAlertAction(title: "카메라로 촬영하기", style: .default) { _ in
            self.openCamera()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(albumButton)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(cancelButton)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openAlbum() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            //
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextView와 TextField
extension ProductRegistrationViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTextFieldTage = textField.tag
        if currentTextFieldTage < 4 {
            textFields[currentTextFieldTage + 1].becomeFirstResponder()
        } else if currentTextFieldTage == 4 {
            descriptionView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let currentTextFieldTage = textField.tag
        if currentTextFieldTage < 4 {
            textFields[currentTextFieldTage + 1].becomeFirstResponder()
        } else if currentTextFieldTage == 4 {
            descriptionView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        passwordField.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkAllRequirementsAreFilled()
    }
}

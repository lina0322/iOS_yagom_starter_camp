//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    @IBOutlet private var titleField: UITextField!
    @IBOutlet private var currencyField: UITextField!
    @IBOutlet private var priceField: UITextField!
    @IBOutlet private var originalPriceField: UITextField!
    @IBOutlet private var stockField: UITextField!
    @IBOutlet private var descriptionTextView: UITextView!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var imageCountLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet weak var registrationButton: UIBarButtonItem!
    private let cancelButton = UIButton()
    private let imagelimitedCapacity = 30_000
    var images: [Data] = [] {
        didSet {
            imageCountLabel.text = String(format: UIString.countOfImage, images.count)
            imageCountLabel.textColor = .black
        }
    }
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
        registorActionToTextFields()
    }
    
    private func registorActionToTextFields() {
        registrationButton.isEnabled = false
        [titleField, currencyField, priceField, stockField, passwordField].forEach {
            $0.addTarget(self, action: #selector(checkAllRequirementsAreFilled), for: .editingChanged)
        }
    }
    
    @objc private func checkAllRequirementsAreFilled() {
        guard let title = titleField.text, !title.isEmpty,
              let currency = currencyField.text, !currency.isEmpty,
              let price = priceField.text, !price.isEmpty,
              let stock = stockField.text, !stock.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              !images.isEmpty else {
            registrationButton.isEnabled = false
            return
        }
        registrationButton.isEnabled = true
    }
    
    @IBAction func touchUpRegistrationButton() {
        postProduct()
    }
    
    @IBAction func touchUpAddImageButton() {
        if images.count < 5 {
            showImagePickerActionSheet()
        } else {
            showErrorAlert(about: UIString.tooManyImage, message: String.empty)
        }
    }
    
    private func setUpPasswordSecure() {
        passwordField.isSecureTextEntry = true
    }
    
    // MARK: - Keyboard
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
        descriptionTextView.inputAccessoryView = toolBarKeyboard
        [titleField, currencyField, priceField, originalPriceField, stockField, passwordField].forEach {
            $0.inputAccessoryView = toolBarKeyboard
        }
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    // MARK: - NavigationBar
    private func configureNavigatinbar() {
        configureCancelButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    private func configureCancelButton() {
        cancelButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        cancelButton.setTitle(UIString.cancel, for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Data
extension ProductRegistrationViewController {
    func postProduct() {
        guard let title = titleField.text, let currency = currencyField.text, let priceText = priceField.text, var price = Int(priceText), let stockText = stockField.text, let stock = Int(stockText), let description = descriptionTextView.text, let password = passwordField.text, images.count > 0 else {
            return
        }
        var discountedPrice: Int? = nil
        if let originalPriceText = originalPriceField.text, let originalPrice = Int(originalPriceText) {
            discountedPrice = price
            price = originalPrice
        }
        
        let product = Product(forPostPassword: password,
                              title: title,
                              descriptions: description,
                              price: price,
                              currency: currency,
                              stock: stock,
                              discountedPrice: discountedPrice,
                              imageFiles: images
        )
        
        Uploader.uploadData(by: .post, product: product, apiRequestType: .postProduct) { result in
            switch result {
            case .success(_):
                self.resetData()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
    
    func resetData() {
        OpenMarketData.shared.productList.removeAll()
        OpenMarketData.shared.currentPage = 1
        self.loadPage(for: nil) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showSuccessAlert(about: UIString.registrationSuccess)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - ImagePicker
extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    private func showImagePickerActionSheet() {
        view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumButton = UIAlertAction(title: UIString.album, style: .default) { _ in
            self.openAlbum()
        }
        let cameraButton = UIAlertAction(title: UIString.camera, style: .default) { _ in
            self.openCamera()
        }
        let cancelButton = UIAlertAction(title: UIString.cancel, style: .cancel, handler: nil)
        
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
        if let originalImage = info[.editedImage] as? UIImage, let image = originalImage.jpegData(compressionQuality: .zero) {
            if image.count > imagelimitedCapacity {
                DispatchQueue.main.async {
                    self.showErrorAlert(about: UIString.bigImage, message: String.empty)
                }
            } else {
                images.append(image)
            }
        }
        checkAllRequirementsAreFilled()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextView & TextField
extension ProductRegistrationViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            currencyField.becomeFirstResponder()
        } else if textField == currencyField {
            priceField.becomeFirstResponder()
        } else if textField == priceField {
            originalPriceField.becomeFirstResponder()
        } else if textField == originalPriceField {
            stockField.becomeFirstResponder()
        } else if textField == stockField {
            descriptionTextView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            currencyField.becomeFirstResponder()
        } else if textField == currencyField {
            priceField.becomeFirstResponder()
        } else if textField == priceField {
            originalPriceField.becomeFirstResponder()
        } else if textField == originalPriceField {
            stockField.becomeFirstResponder()
        } else if textField == stockField {
            descriptionTextView.becomeFirstResponder()
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

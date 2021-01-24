//
//  ToastMessage.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/23.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        let labelWidth: CGFloat = 250
        let labelHeight: CGFloat = 35
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - labelWidth/2, y: self.view.frame.size.height-50, width: labelWidth, height: labelHeight))
        
        toastLabel.backgroundColor = .gray
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

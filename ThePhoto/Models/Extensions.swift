//
//  Extensions.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import Foundation

//encode edilen datayı [string : any] dictionary yapacak.firestore verilerini işlemek için. STRUCT TO JSON
extension Encodable {
    func asDictionary() -> [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        return json
    }
}

//JSON TO STRUCT
extension Decodable {
    init?(with dictionary : [String : Any]){
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = result
    }
}

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func dateString(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}


//to try some feed problems
/* override func viewDidLoad() {
     super.viewDidLoad()
     view.backgroundColor = .systemBackground
     view.addSubview(cameraButton)
     cameraButton.addTarget(self, action: #selector(didTapCameraButton), for: UIControl.Event.touchUpInside)
 }
 private let cameraButton : UIButton = {
     let button = UIButton()
     button.setImage(UIImage(systemName: "camera.badge.clock"), for: UIControl.State.normal)
     button.backgroundColor = .systemBackground
     button.layer.borderWidth = 1
     button.layer.borderColor = UIColor.secondaryLabel.cgColor
     button.tintColor = .label
     return button
 }()
 
 
 override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     let widht = view.frame.size.width
     let height = view.frame.size.height
     
     cameraButton.frame = CGRect(x: widht * 0.93 - (widht * 0.07) / 2 , y: height * 0.72 - (widht * 0.07) / 2, width: widht * 0.07, height: widht * 0.07)
     cameraButton.layer.cornerRadius = (widht * 0.07) / 2
 }
 
 
 @objc func didTapCameraButton(){
     let sheet = UIAlertController(title: "New Challange Time", message: "Share new post", preferredStyle: UIAlertController.Style.actionSheet)
     
     sheet.addAction(UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
         DispatchQueue.main.async {
             let picker = UIImagePickerController()
             picker.sourceType = .camera
             picker.delegate = self
             picker.allowsEditing = true
             self?.present(picker, animated: true)
         }
     }))
     
     sheet.addAction(UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
         DispatchQueue.main.async {
             let picker = UIImagePickerController()
             picker.sourceType = .photoLibrary
             picker.delegate = self
             picker.allowsEditing = true
             self?.present(picker, animated: true)
         }
     }))
     
     sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
     
     present(sheet, animated: true)
 
 }
 
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
         return
     }
     let vc = PostShareViewController(image: image)
     navigationController?.pushViewController(vc, animated: true)
     dismiss(animated: true)
 }*/

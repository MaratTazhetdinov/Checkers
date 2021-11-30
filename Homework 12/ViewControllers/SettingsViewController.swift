//
//  SettingsViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var selectDeskImageButton: CustomButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var checkersStyleCollectionView: UICollectionView!
    @IBOutlet weak var checkersStyleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ruImage: UIImageView!
    @IBOutlet weak var enImage: UIImageView!
    
    var selectedCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCellIndex = CheckersSettings.shared.checkersStyle
        selectDeskImageButton.delegate = self
        setupCollectionView()
        localized()
    }
    
    func localized() {
        checkersStyleLabel.text = "checkersStylelabel".localized
        selectDeskImageButton.text = "changeDeskButton".localized
        resetButton.setTitle("resetButton".localized, for: .normal)
        languageLabel.text = "languageLabel".localized
        backButton.setTitle("backMainMenuLabel".localized, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.addBorder(with: .black, borderWidth: 3.0)
        backButton.layer.cornerRadius = backButton.frame.size.height / 4.5
        infoButton.addBorder(with: .black, borderWidth: 3.0)
        infoButton.layer.cornerRadius = infoButton.frame.size.height / 2.0
        resetButton.addBorder(with: .black, borderWidth: 3.0)
        resetButton.layer.cornerRadius = resetButton.frame.size.height / 2.0
        checkersStyleCollectionView.layer.cornerRadius = checkersStyleCollectionView.frame.size.height / 4.0
        checkersStyleCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        
        if CheckersSettings.shared.currentLanguage == "en" {
            enImage.addBorder(with: .black, borderWidth: 2.0)
        } else {
            ruImage.addBorder(with: .black, borderWidth: 2.0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        CheckersSettings.shared.save()
    }
    
    func setupCollectionView () {
        checkersStyleCollectionView.dataSource = self
        checkersStyleCollectionView.delegate = self
        checkersStyleCollectionView.register(UINib(nibName: "CheckerStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CheckerStyleCollectionViewCell")
    }
    
    func selectDeskImage () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func goToNewVCButtonAction (_ sender : UIButton) {
//        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController"), animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InfoViewController")
        vc.viewWillAppear(true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        CheckersSettings.shared.deskImage = UIImage(named: "Table")
    }
    
    @IBAction func ruButtonAction(_ sender: Any) {
        CheckersSettings.shared.currentLanguage = "ru"
        ruImage.addBorder(with: .black, borderWidth: 2.0)
        enImage.addBorder(with: .clear, borderWidth: 0.0)
        localized()
    }
    
    @IBAction func enButtonAction(_ sender: Any) {
        CheckersSettings.shared.currentLanguage = "en"
        enImage.addBorder(with: .black, borderWidth: 2.0)
        ruImage.addBorder(with: .clear, borderWidth: 0.0)
        localized()
    }
}

extension SettingsViewController: CustomButtonDelegate {
    func customButtonDidTap(_sender: CustomButton) {
        selectDeskImage()
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        CheckersSettings.shared.deskImage = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = checkersStyleCollectionView.dequeueReusableCell(withReuseIdentifier: "CheckerStyleCollectionViewCell", for: indexPath) as? CheckerStyleCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(with: "WhiteChecker\(indexPath.item)", imageName2: "BlackChecker\(indexPath.item)")
        if indexPath.item == selectedCellIndex {
            cell.isSelected = true
            cell.toggleSelected()
        } else {
            cell.isSelected = false
            cell.toggleSelected()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CheckersSettings.shared.checkersStyle = indexPath.item
        let cell = checkersStyleCollectionView.cellForItem(at: indexPath) as? CheckerStyleCollectionViewCell
        cell?.isSelected = true
        selectedCellIndex = indexPath.item
        cell?.toggleSelected()
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = checkersStyleCollectionView.cellForItem(at: indexPath) as? CheckerStyleCollectionViewCell
        cell?.isSelected = false
        cell?.toggleSelected()
    }
}

extension SettingsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 90)
    }
}

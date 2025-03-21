//
//  ViewControllerExtension.swift
//  assessment
//
//  Created by kpc02007-macb3 on 3/21/25.
//

import UIKit

 // MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.countriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCells", for: indexPath)
        cell.textLabel?.text = countriesViewModel.countriesList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countriesViewModel.countriesList[indexPath.row]
        searchTextField.text = selectedCountry
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, searchField searched: String?) {
        
        guard let search = searched, !search.isEmpty else {
            tableView.isHidden = true
            tableView.reloadData()
            return
        }
        
        countriesViewModel.countriesList = countriesViewModel.filteredCountries.sorted().filter {$0.localizedCaseInsensitiveContains(search)}
        countriesViewModel.countriesList = Array(countriesViewModel.countriesList.prefix(3))
        tableView.isHidden = false
        
        tableView.reloadData()
    }
}


// MARK: - TextField
extension ViewController: UITextFieldDelegate {
    
    func textFieldStyle(_ textField: UITextField, isValid: Bool, errorLabel label: UILabel) {
        if isValid {
            textField.layer.borderColor = UIColor.clear.cgColor
            label.isHidden = true
        }else {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 5.0
            textField.layer.borderWidth = 1.0
            label.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == stateTextField, let region = textField.text {
            countriesViewModel.filterCountries(by: region)
        }
        countriesTableView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTextField {
            tableView(countriesTableView, searchField: textField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = searchTextField{
            if let currentText = textField.text,
               let textRange = Range(range, in: currentText) {
                let search = currentText.replacingCharacters(in: textRange, with: string)
                tableView(countriesTableView, searchField: search)
            }
        }
        return true
    }
}

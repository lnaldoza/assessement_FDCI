//
//  ViewController.swift
//  assessment
//
//  Created by kpc02007-macb3 on 3/21/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var stateError: UILabel!
    @IBOutlet weak var searchError: UILabel!
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    let countriesViewModel = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchError.isHidden = true
        stateError.isHidden = true
        nameError.isHidden = true
        countriesTableView.isHidden = true
        
        searchTextField.delegate = self
        stateTextField.delegate = self
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        countriesViewModel.fetchCountries()
//        countriesViewModel.getCountries()
    }

    @IBAction func submitButton(_ sender: Any) {
        var errors: [String] = []
        
        countriesViewModel.filterCountries(by: stateTextField.text ?? "")
        
        if let name = nameTextField.text {
            if !countriesViewModel.isValidName(name) {
                let errorMessage = "Cannot contain non-alphanumeric characters"
                nameError.text = errorMessage
                errors.append(errorMessage)
                
                textFieldStyle(nameTextField, isValid: false, errorLabel: nameError)
            } else {
                textFieldStyle(nameTextField, isValid: true, errorLabel: nameError)
            }
        }

        if let region = stateTextField.text {
            if !countriesViewModel.isValidRegion(region) {
                let errorMessage = "Region value is not valid"
                stateError.text = errorMessage
                errors.append(errorMessage)
                
                textFieldStyle(stateTextField, isValid: false, errorLabel: stateError)
            } else {
                textFieldStyle(stateTextField, isValid: true, errorLabel: stateError)
            }
        }

        if let country = searchTextField.text {
            if !countriesViewModel.isValidCountry(country) {
                let errorMessage = "Selected country is not valid"
                searchError.text = errorMessage
                errors.append(errorMessage)
                
                textFieldStyle(searchTextField, isValid: false, errorLabel: searchError)
            } else {
                textFieldStyle(searchTextField, isValid: true, errorLabel: searchError)
            }
        }
    
        if errors.isEmpty {
            showDialog(nameValue: nameTextField.text!, regionValue: stateTextField.text!, countryValue: searchTextField.text!)
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        nameTextField.text = ""
        stateTextField.text = ""
        searchTextField.text = ""
        
        searchError.isHidden = true
        stateError.isHidden = true
        nameError.isHidden = true
        
        nameTextField.layer.borderColor = UIColor.clear.cgColor
        stateTextField.layer.borderColor = UIColor.clear.cgColor
        searchTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: Message Dialog
    func showDialog(nameValue name: String, regionValue region: String, countryValue country: String) {
        let message = """
                   Name: \(name)
                   Region: \(region)
                   Country: \(country)
                   """
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}


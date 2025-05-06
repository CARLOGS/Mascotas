//
//  DetailView.swift
//  Pets
//
//  Created by Ángel González on 19/10/24.
//

import UIKit
import IQKeyboardReturnManager

class DetailView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let btnDelete = UIButton(type: .system)
    let txtNombre = UITextField()
    let txtTipo = UITextField()
    let txtGenero = UITextField()
    let txtEdad = UITextField()
    let btnAdopt = UIButton(type: .custom)
    let lblResponsable = UILabel()
    // Campos nuevos para Adoptar
    let btnUp = UIButton(type: .system)
    let btnDown = UIButton(type: .system)
    let lblSearch = UILabel()
    let btnDone = UIButton(type: .system)
    let pckResponsables = UIPickerView()
    var selectedIndex: Int = 0
    var responsables: [Responsable] = []
    let returnManager: IQKeyboardReturnManager = .init()
    
    override func draw(_ rect: CGRect) {
        // Crear el stack view
        let stackView = UIStackView()
        let stackView2 = UIStackView()
        let stackViewH = UIStackView()
        
        // Configurar propiedades del stack view
        stackView.axis = .vertical // Disposición vertical
        stackView.spacing = 15 // Espaciado entre los elementos
        stackView.alignment = .fill // Alinear a llenar el espacio
        stackView.translatesAutoresizingMaskIntoConstraints = false // Utilizar Auto Layout
        
        // Configurar propiedades del stack view
        stackView2.axis = .vertical // Disposición vertical
        stackView2.spacing = 15 // Espaciado entre los elementos
        stackView2.alignment = .fill // Alinear a llenar el espacio
        stackView2.translatesAutoresizingMaskIntoConstraints = false // Utilizar Auto Layout
        
        stackViewH.axis = .horizontal // Disposición horizontal
        stackViewH.spacing = 10
        stackViewH.alignment = .center
        stackViewH.distribution = .fillProportionally
        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        stackViewH.backgroundColor = .systemGray6
        
        // Agregamos los elementos:
        txtNombre.borderStyle = .roundedRect // Estilo del borde
        txtNombre.placeholder = "Nombre" // Texto de marcador
        stackView.addArrangedSubview(txtNombre) // Agregar al stack view
        
        txtGenero.borderStyle = .roundedRect // Estilo del borde
        txtGenero.placeholder = "Género" // Texto de marcador
        stackView.addArrangedSubview(txtGenero) // Agregar al stack view
        
        txtTipo.borderStyle = .roundedRect // Estilo del borde
        txtTipo.placeholder = "Tipo" // Texto de marcador
        stackView.addArrangedSubview(txtTipo) // Agregar al stack view
        
        txtEdad.borderStyle = .roundedRect // Estilo del borde
        txtEdad.placeholder = "Edad" // Texto de marcador
        // Delegado solo al último campo si quieres hacer algo especial al presionar "Done"
        txtEdad.delegate = self
        stackView.addArrangedSubview(txtEdad) // Agregar al stack view
        
        // Se implementa el pase de campo en campo hata el último realiza el DONE
        returnManager.addResponderSubviews(of: self, recursive: true)
        returnManager.dismissTextViewOnReturn = true
        returnManager.lastTextInputViewReturnKeyType = .done
        returnManager.add(textInputView: txtNombre)
        returnManager.add(textInputView: txtGenero)
        returnManager.add(textInputView: txtTipo)
        returnManager.add(textInputView: txtEdad)
        
        btnAdopt.backgroundColor = .red
        btnAdopt.setTitle("Adoptar", for: .normal)
        stackView.addArrangedSubview(btnAdopt)
        
        lblResponsable.backgroundColor = .red.withAlphaComponent(0.5)
        lblResponsable.textColor = .white
        stackView.addArrangedSubview(lblResponsable)
        
        btnDelete.setImage(UIImage(systemName: "pip.remove"), for: .normal)
        stackView.addArrangedSubview(btnDelete)
        
        // Botón Up
        btnUp.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        btnUp.tintColor = .black
        btnUp.isHidden = true
        
        // Botón Down
        btnDown.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btnDown.tintColor = .black
        btnDown.isHidden = true
        
        // Etiqueta de selección
        lblSearch.text = "Seleccionar ..."
        lblSearch.textColor = .gray
        lblSearch.font = .systemFont(ofSize: 10)
        lblSearch.textAlignment = .natural
        lblSearch.isHidden = true
        
        // Botón Done
        btnDone.setTitle(String?("Done"), for: .normal)
        btnDone.tintColor = .black
        btnDone.isHidden = true
        
        lblSearch.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Agregar al Horizontal stack
        stackViewH.addArrangedSubview(btnUp)
        stackViewH.addArrangedSubview(btnDown)
        stackViewH.addArrangedSubview(lblSearch)
        stackViewH.addArrangedSubview(btnDone)
        
        // Esaciador
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: 20).isActive = true // o .heightAnchor para stack vertical
        
        stackView2.addArrangedSubview(stackViewH)
        
        returnManager.addResponderSubviews(of: btnDone, recursive: true)
        returnManager.dismissTextViewOnReturn = true
        
        // Llena el Picker con los Responsables
        responsables = DataManager.shared.todosLosResponsables()
        pckResponsables.delegate = self
        pckResponsables.dataSource = self
        pckResponsables.isHidden = true
        stackView2.addArrangedSubview(pckResponsables)
        
        // Agregar el stack view a la vista principal
        self.addSubview(stackView)
        self.addSubview(stackView2)

        // Configurar las restricciones del stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centrar horizontalmente
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6), // Ancho del stack view
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40)
            
        ])
        
        // Configurar las restricciones del stack view
        NSLayoutConstraint.activate([
            stackView2.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centrar horizontalmente
            stackView2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0), // Ancho del stack view
            stackView2.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        btnUp.isEnabled = false
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnUp.isEnabled = row > 0
        btnDown.isEnabled = row < (responsables.count - 1)
        
        selectedIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        responsables.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ((responsables[row].nombre) ?? "") + " " + ((responsables[row].apellido_paterno) ?? "")
    }

    // Acción del DONE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEdad {
            // Aquí el usuario presionó "Done" en el último campo
            textField.resignFirstResponder() // Cierra el teclado
            
            // Aquí puedes hacer lo que necesites: validar, enviar, etc.
            print("Presionaste Done en el último campo")
            
            btnAdopt.isEnabled = false
            btnDelete.isEnabled = false
            
            btnUp.isHidden = false
            btnDown.isHidden = false
            lblSearch.isHidden = false
            btnDone.isHidden = false
            pckResponsables.isHidden = false
        }
        return true
    }
}

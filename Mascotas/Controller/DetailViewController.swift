//
//  ViewController.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import UIKit

class DetailViewController: UIViewController {

    var laMascota : Mascota!
    var detalle: DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        detalle = DetailView(frame:view.bounds.insetBy(dx: 0, dy: 0))
        view.addSubview(detalle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: - Obtener y presentar la información de la mascota
        detalle.txtNombre.text = laMascota.nombre ?? ""
        detalle.txtGenero.text = laMascota.genero ?? ""
        detalle.txtTipo.text = laMascota.tipo ?? ""
        detalle.txtEdad.text = "\(laMascota.edad)"
        detalle.btnAdopt.addTarget(self, action:#selector(adoptar), for:.touchUpInside)
        detalle.btnDelete.addTarget(self, action:#selector(borrar), for:.touchUpInside)
        detalle.btnUp.addTarget(self, action:#selector(moveUp), for:.touchUpInside)
        detalle.btnDown.addTarget(self, action:#selector(moveDown), for:.touchUpInside)
        detalle.btnDone.addTarget(self, action:#selector(doneAdopt), for:.touchUpInside)

        // TODO: - Si la mascota ya tiene un responsable, ocultar el botón
        if laMascota.responsable != nil {
            detalle.btnAdopt.isHidden = true
            let ownerInfo = ((laMascota.responsable?.nombre) ?? "") + " " + ((laMascota.responsable?.apellido_paterno) ?? "")
            detalle.lblResponsable.isHidden = false
            detalle.lblResponsable.frame.size.height = 50
            detalle.lblResponsable.text = "Dueño: \(ownerInfo)"
            detalle.lblResponsable.sizeToFit()
            // Oculta la lista de responsables
            detalle.pckResponsables.isHidden = true
        }
        else {
            detalle.btnAdopt.isHidden = false
            detalle.lblResponsable.isHidden = true
            detalle.lblResponsable.frame.size.height = 0
            // Muestra lista de responsables
            detalle.pckResponsables.isHidden = false
        }
    }
    
    @objc
    func borrar () {
        let ac = UIAlertController(title: "CONFIRME", message:"Desea borrar este registro?", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .destructive) {
            alertaction in
            DataManager.shared.borrar(objeto:self.laMascota)
            // si se implementa con navigation controller:
            self.navigationController?.popViewController(animated: true)
            // self.dismiss(animated: true)
        }
        let action2 = UIAlertAction(title: "NO", style:.cancel)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
    
    @objc
    func adoptar () {
        detalle.btnAdopt.isEnabled = false
        detalle.btnDelete.isEnabled = false
        
        detalle.btnUp.isHidden = false
        detalle.btnDown.isHidden = false
        detalle.lblSearch.isHidden = false
        detalle.btnDone.isHidden = false
        detalle.pckResponsables.isHidden = false
    }
    
    @objc
    func moveUp () {
        detalle.btnUp.isEnabled = detalle.selectedIndex > 0

        if ( detalle.btnUp.isEnabled ) {
            detalle.selectedIndex = detalle.selectedIndex - 1
            detalle.pckResponsables.selectRow(detalle.selectedIndex, inComponent: 0, animated: true)
            
            detalle.btnUp.isEnabled = detalle.selectedIndex > 0
            detalle.btnDown.isEnabled = detalle.selectedIndex < (detalle.responsables.count - 1)
        }
    }
    
    @objc
    func moveDown () {
        detalle.btnDown.isEnabled = detalle.selectedIndex < (detalle.responsables.count - 1)
        
        if ( detalle.btnDown.isEnabled ) {
            detalle.selectedIndex = detalle.selectedIndex + 1
            detalle.pckResponsables.selectRow(detalle.selectedIndex, inComponent: 0, animated: true)
            
            detalle.btnUp.isEnabled = detalle.selectedIndex > 0
            detalle.btnDown.isEnabled = detalle.selectedIndex < (detalle.responsables.count - 1)
        }
    }
    
    @objc
    func doneAdopt () {
        let ac = UIAlertController(title: "CONFIRME", message:"Desea adoptar a \(self.laMascota.nombre ?? "")?", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .destructive) {
            alertaction in
            DataManager.shared.adopta(
                mascota: self.laMascota,
                responsable: self.detalle.responsables[self.detalle.selectedIndex]
            )
            // si se implementa con navigation controller:
            self.navigationController?.popViewController(animated: true)
            // self.dismiss(animated: true)
        }
        let action2 = UIAlertAction(title: "NO", style:.cancel)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
}


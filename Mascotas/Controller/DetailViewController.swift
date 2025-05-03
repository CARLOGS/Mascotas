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
        detalle = DetailView(frame:view.bounds.insetBy(dx: 40, dy: 40))
        view.addSubview(detalle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: - Obtener y presentar la información de la mascota
        detalle.txtNombre.text = laMascota.nombre ?? ""
        detalle.txtGenero.text = laMascota.genero ?? ""
        detalle.txtTipo.text = laMascota.tipo ?? ""
        detalle.txtEdad.text = "\(laMascota.edad)"
        detalle.btnDelete.addTarget(self, action:#selector(borrar), for:.touchUpInside)
        
        // TODO: - Si la mascota ya tiene un responsable, ocultar el botón
    }
    
    @objc
    func borrar () {
        let ac = UIAlertController(title: "CONFIRME", message:"Desea borrar este registro?", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .destructive) {
            alertaction in
            DataManager.shared.borrar(objeto:self.laMascota)
            self.dismiss(animated: true)
        }
        let action2 = UIAlertAction(title: "NO", style:.cancel)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)

    }
}


//
//  TableViewController.swift
//  ExampleCoreDataObject
//
//  Created by gerardo on 11/01/18.
//  Copyright © 2018 Orbis. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    var managedObjects:[Persona] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        recuperarDatosCoreDate()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managedObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = managedObjects[indexPath.row].nombre
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let nombre = managedObjects[indexPath.row].value(forKeyPath: "nombre") as? String else {
                return
            }
            eliminarRegistro(nombre: nombre)
            recuperarDatosCoreDate()
            tableView.reloadData()
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedcontext = appDelegate!.persistentContainer.viewContext
        return managedcontext
    }

    @IBAction func IngresarAlumno(_ sender: Any) {
        let alerta = UIAlertController(title: "Nueva Alumno", message: "Por favor agrega el nombre del nuevo alumno", preferredStyle: .alert)
        let guardar = UIAlertAction(title: "agregar", style: .default) { (action) in
            let texField = alerta.textFields?.first
            self.registrarNombre(nombre: (texField?.text)!)
            self.tableView.reloadData()
        }
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel) { (action) in
        }
        alerta.addTextField { (texField:UITextField) in
        }
        alerta.addAction(guardar)
        alerta.addAction(cancelar)
        self.present(alerta, animated: true) {
        }
    }

    func registrarNombre(nombre: String) {
        let managedcontext = getContext()
        // 1. creamos una variable objeto del tipo de nuestra entidad (en este caso Persona).
        let entity = NSEntityDescription.entity(forEntityName: "Persona", in: managedcontext) // debes de colocar el nombre de tu base de datos
        let persona = Persona(entity: entity!, insertInto: managedcontext)
        // 2. Registramos nuestro valor en  el managedObject
        persona.nombre = nombre// forKeyPath: el nombre del atributo
        // 3. utilizando nuestro managedcontext guardaremos los cambios.
        do {
            try managedcontext.save()
            managedObjects.append(persona)
        } catch let error as NSError{
            print("No se pudo guardar, error: \(error), \(error.userInfo)")
        }
    }

    func recuperarDatosCoreDate() {
        let managedcontext = getContext()
        // 1. Usaremos fetch para buscar, traer y extraer.
        let fetchRequest = NSFetchRequest<Persona>(entityName: "Persona")
        // 2. do y catch
        do {
            managedObjects = try managedcontext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No se pudo recuperar los datos, error: \(error), \(error.userInfo)")
        }
    }

    func eliminarRegistro(nombre: String) {
        let managedcontext = getContext()
        let fetchRequest = NSFetchRequest<Persona>(entityName: "Persona")
        fetchRequest.predicate = NSPredicate(format: "nombre == %@", nombre)
        let object = try! managedcontext.fetch(fetchRequest)
        do {
            managedcontext.delete(object.first!)
            try managedcontext.save()
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }
}

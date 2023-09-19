//
//  ViewController.swift
//  Pesquisa_Cep
//
//  Created by COTEMIG on 21/06/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtCep: UITextField!
    @IBOutlet weak var txtResult: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        self.txtResult.text = ""
        guard let cep = txtCep.text,
              !cep.isEmpty && cep.count == 8 else{
            self.txtResult.text = "Cep é obrigatório (com 8 dígitos numéricos)"
            return
        }
        if let url = URL(string: "https://viacep.com.br/ws/\(cep)/json/") {
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url){ [weak self] data, response, error in
                guard let self = self else{ return }
                if let resultData = data {
                    print(resultData)
                    do{
                        let localStruct = try JSONDecoder().decode(CepResponseData.self, from: resultData)
                        DispatchQueue.main.async {
                            self.txtResult.text = localStruct.toString()
                        }
                    } catch{
                        print("==> Erro no parser da struct")
                    }
                }
                if let resultError = error {
                    print("==> Erro na requisição: \(resultError)")
                }
            }.resume()
            
        }
    }
}


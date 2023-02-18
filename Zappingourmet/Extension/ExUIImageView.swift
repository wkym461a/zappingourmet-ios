//
//  ExUIImageView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/18.
//

import UIKit

extension UIImageView {
    
    func loadImage(contentOf url: URL, completion: @escaping ((_ succeeded: Bool, _ image: UIImage?) -> Void) = { _, _  in }) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(#function, error)
                return
            }
            
            guard
                let data = data,
                let image = UIImage(data: data)

            else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                completion(true, image)
            }


        }.resume()
    }
    
}

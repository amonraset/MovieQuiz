

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    func alertEnd(alend: AlertModel) {
        
        let alert = UIAlertController(
            title: alend.title,
            message: alend.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alend.buttonText, style: .default) { _ in
            alend.completion()
        }
        alert.addAction(action) //создание кнопки
        delegate?.present(alert, animated: true, completion: nil)
    }
}


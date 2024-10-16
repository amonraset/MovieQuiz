
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
        alert.view.accessibilityIdentifier = "alert"
        
        let action = UIAlertAction(title: alend.buttonText, style: .default) { _ in alend.completion()}
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}


#if DEBUG
import UIKit

final class CrudTextField: UITextField, DEBUGCrudDomainFieldView {
    var value: Any? {
        get { text }
        set { text = newValue as? String }
    }
    
    static func create() -> CrudTextField {
        let tf = CrudTextField()
        tf.borderStyle = .roundedRect
        return tf
    }
}

final class CrudDatePicker: UIStackView, DEBUGCrudDomainFieldView {
    private lazy var datePicker = UIDatePicker()
        .configure { (v) in
            self.axis = .vertical
            self.addArrangedSubview(dateLabel)
            self.addArrangedSubview(v)
            v.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        }
    private lazy var dateLabel = UILabel()
    
    var value: Any? {
        get {
            defer { dateLabel.text = "\(datePicker.date)" }
            return datePicker.date
        }
        set {
            datePicker.date = newValue as! Date
            dateLabel.text = "\(datePicker.date)"
        }
    }
    
    @objc
    private func onDateChanged(_ sender: UIDatePicker) {
        value = sender.date
    }
    
    static func create() -> CrudDatePicker {
        let v = CrudDatePicker()
        return v
    }
}

#endif

import UIKit

struct AppConstants {

    enum SystemImages {
        static let starGray = UIImage(named: "starGray")
        static let starGold = UIImage(named: "starGold")

        static let share = UIImage(systemName: "square.and.arrow.up")
        static let delete = UIImage(systemName: "trash")
        static let microphone = UIImage(systemName: "microphone.fill")
        static let taskCompleted = UIImage(systemName: "checkmark.circle")
        static let taskNotCompleted = UIImage(systemName: "circle")
    }

    enum Colors {
        static let black = UIColor(hex: "1A1A1A")
        static let gray = UIColor(hex: "BABABA")
        static let brightGray = UIColor(hex: "F0F4F7")
        static let green = UIColor(hex: "24B25D")
        static let red = UIColor(hex: "B22424")
    }

    enum Insets {
        static let small4: CGFloat = 4
        static let medium8: CGFloat = 8
        static let large12: CGFloat = 12
    }

    enum CornerRadius {
        static let medium16: CGFloat = 16
        static let large20: CGFloat = 20
    }

    enum Fonts {
        static let headline = UIFont(name: "Montserrat-Bold", size: 28)
        static let regular = UIFont(name: "Montserrat-Bold", size: 18)
        static let searchBar = UIFont(name: "Montserrat-SemiBold", size: 16)
        static let searchPlaceholder = UIFont(name: "Montserrat-SemiBold", size: 12)
        static let body = UIFont(name: "Montserrat-SemiBold", size: 11)
    }

    enum alertsError {
        static let loadingError = "Ошибка загрузки данных"
    }

    enum UserDefaultsKeys {
        static let favourites = "favourites"
    }

//    enum Height {
//        static let textField: CGFloat = 50
//    }
}

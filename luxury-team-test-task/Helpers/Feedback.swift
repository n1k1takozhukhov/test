import UIKit

struct FeedbackGeneratorHelper {

    // MARK: Properties

    enum FeedbackType: String {

        case notificationSuccess
        case notificationWarning
        case notificationError

        case impactLight
        case impactMedium
        case impactHeavy
        case impactSoft
        case impactRigid

        case selection

    }
    // MARK: Public

    static func run(_ type: FeedbackType) {
        switch type {
        case .notificationSuccess: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .notificationWarning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .notificationError:   UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .impactLight:         UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .impactMedium:        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .impactHeavy:         UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .impactSoft:          UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .impactRigid:         UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .selection:           UISelectionFeedbackGenerator().selectionChanged()
        }
    }

}

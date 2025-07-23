import Foundation

enum UserDefaultsKey: String, CaseIterable {

    // MARK: Common

    case appVersion
    case appBuild
    case didAppTerminated
    case launchedBefore

}

protocol StorageService: AnyObject {

    var isAppFirstLaunch: Bool { get }

    func saveInUserDefaults(value: Any, with key: UserDefaultsKey)
    func numberFromUserDefaults(with key: UserDefaultsKey) -> Int?
    func stringFromUserDefaults(with key: UserDefaultsKey) -> String?
    func boolFromUserDefaults(with key: UserDefaultsKey) -> Bool

}

final class StorageServiceImplementation: StorageService {

    // MARK: Properties

    private let userDefaults: UserDefaults

    internal var isAppFirstLaunch: Bool {
        !userDefaults.bool(forKey: UserDefaultsKey.launchedBefore.rawValue)
    }

    // MARK: Initializers

    required init(userDefaults: UserDefaults = UserDefaults()) {
        self.userDefaults = userDefaults
    }

    // MARK: StorageService

    func saveInUserDefaults(value: Any, with key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    func numberFromUserDefaults(with key: UserDefaultsKey) -> Int? {
        userDefaults.integer(forKey: key.rawValue)
    }

    func stringFromUserDefaults(with key: UserDefaultsKey) -> String? {
        userDefaults.string(forKey: key.rawValue)
    }

    func boolFromUserDefaults(with key: UserDefaultsKey) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }

}

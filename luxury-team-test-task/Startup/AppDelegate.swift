import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private var storageService: StorageService?

    // MARK: Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogsService.info("App launched")
        startup()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LogsService.info("")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        LogsService.info("")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LogsService.info("")
        guard window == nil else { return }
        startup()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LogsService.info("")
    }

    // MARK: Private

    private func startup() {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        setupServices()
    }

    private func setupServices() {
        storageService = StorageServiceImplementation()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "luxury_team_test_task")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

import CoreData
import UIKit

final class CoreDataServiceImplementation {

    // MARK: Properties

    let context: NSManagedObjectContext

    // MARK: Initializers

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    func saveContext() {
        guard context.hasChanges else { return }

        LogsService.warning("Attempting to save context")

        do {
            try context.save()
            LogsService.info("Context saved successfully")
        }
        catch {
            LogsService.error("Failed to save context: \(error.localizedDescription)")
        }
    }

}

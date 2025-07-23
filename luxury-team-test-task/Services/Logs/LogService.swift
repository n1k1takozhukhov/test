import Foundation
import OSLog

final class LogsService {

    // MARK: Properties

    enum LogLevel: String {
        case info = "🟢 INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
        case debug = "🐞 DEBUG"
        case network = "🌐 NETWORK"
    }

    static let logger: Logger = {
        let subsystem = Bundle.main.bundleIdentifier ?? "default"
        let logger = Logger(subsystem: subsystem, category: "general-log")
        return logger
    }()

    // MARK: LogsService

    static func log(level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let fullMessage = "\(level.rawValue) [\(fileName):\(line)] \(function): \(message)"

        let subsystem = Bundle.main.bundleIdentifier ?? "default"
        let logger = Logger(subsystem: subsystem, category: "general-log")

        switch level {
        case .info:
            logger.info("\(fullMessage)")
        case .warning:
            logger.warning("\(fullMessage)")
        case .error:
            logger.error("\(fullMessage)")
        case .debug:
            logger.debug("\(fullMessage)")
        default:
            break
        }
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message, file: file, function: function, line: line)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warning, message, file: file, function: function, line: line)
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message, file: file, function: function, line: line)
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message, file: file, function: function, line: line)
    }

    static func network(_ body: [String: Any], data: Data?) {
        var dataString = "-"
        if let data, let utf8Text = String(data: data, encoding: .utf8) {
            dataString = utf8Text
        }
        let fullMessage = "\(LogLevel.network.rawValue)\n-> BODY: \(body)\n-> DATA: \(dataString)"

        logger.debug("\(fullMessage)")
    }

}

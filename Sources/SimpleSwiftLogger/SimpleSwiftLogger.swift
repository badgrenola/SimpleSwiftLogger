import Foundation

final public class SimpleSwiftLogger {
    
    //Define available log levels
    enum LogLevel: Int {
        case verbose
        case debug
        case info
        case warning
        case error
        
        //Implement comparisons require to filter levels less than minLogLevel
        static func > (lhs:Self, rhs:Self) -> Bool { return lhs.rawValue > rhs.rawValue }
    }
    
    public var minLogLevel : LogLevel = .info
    private let formatter = DateFormatter()
    
    public init() {
        formatter.dateFormat = "HH:mm:ss"
    }
    
    private func verbose(_ obj: Any) {
        if (minLogLevel > LogLevel.verbose) { return }
        print("\(formatter.string(from: Date())) 🟪 \(getLoggable(obj))")
    }
    private func debug(_ obj: Any) {
        if (minLogLevel > LogLevel.debug) { return }
        print("\(formatter.string(from: Date())) 🟩 \(getLoggable(obj))")
    }
    private func info(_ obj: Any) {
        if (minLogLevel > LogLevel.info) { return }
        print("\(formatter.string(from: Date())) 🟦 \(getLoggable(obj))")
    }
    private func warning(_ obj: Any) {
        if (minLogLevel > LogLevel.warning) { return }
        print("\(formatter.string(from: Date())) 🟨 WARNING \(getLoggable(obj))")
    }
    private func error(_ obj: Any) {
        if (minLogLevel > LogLevel.error) { return }
        print("\(formatter.string(from: Date())) 🟥 ERROR \(getLoggable(obj))")
    }
    
    private func getLoggable(_ obj: Any) -> String {
        if let s = obj as? String { return s }
        if let e = obj as? Error { return e.localizedDescription }
        return "\(obj)"
    }
}

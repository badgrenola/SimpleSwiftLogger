import Foundation

final public class SimpleSwiftLogger {
    
    //Define available log levels
    public enum LogLevel: String, CaseIterable {
        case verbose = "🟪"
        case debug = "🟩"
        case info = "🟦"
        case warning = "🟨"
        case error = "🟥"
        
        private func toInt() -> Int { LogLevel.allCases.firstIndex(of: self)! }
        
        //Implement comparisons require to filter levels less than minLogLevel
        static func > (lhs:Self, rhs:Self) -> Bool { return lhs.toInt() > rhs.toInt() }
    }
    
    //Define public vars
    public var minLogLevel : LogLevel = .info
    public var name : String?
    public var showLoggerName : Bool = true
    public var showFileName : Bool = true
    public var showFunctionName : Bool = false
    public var showLineNumber : Bool = false

    //Create a single formatter that can be reused
    private let formatter = DateFormatter()
    
    //MARK: - Init
    public init(minLogLevel: LogLevel = .info, name: String? = nil) {
        formatter.dateFormat = "HH:mm:ss"
        self.minLogLevel = minLogLevel
        self.name = name
    }
    
    //MARK: - Public logging functions - pass in file/line/function with default vals so we can use them in the output
    public func verbose(_ obj: Any, sourceClass: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .verbose, obj: obj, file: file, line: line, function: function)
    }
    public func debug(_ obj: Any, sourceClass: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, obj: obj, file: file, line: line, function: function)
    }
    public func info(_ obj: Any, sourceClass: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, obj: obj, file: file, line: line, function: function)
    }
    public func warning(_ obj: Any, sourceClass: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .warning, obj: obj, file: file, line: line, function: function)
    }
    public func error(_ obj: Any, sourceClass: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .error, obj: obj, file: file, line: line, function: function)
    }
    
    //MARK: - Define the internal log method
    private func log(level: LogLevel, obj: Any, file: String, line: Int, function: String) {
        if (minLogLevel > level) { return }
        
        //Create an array of each of the required strings in order. If not required, value is nil
        let detailStrings : [String?] = [
            formatter.string(from: Date()),
            level.rawValue,
            showLoggerName && name != nil ? "\(name!) :" : nil,
            showFileName ? (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "") : nil,
            showFunctionName ? function.replacingOccurrences(of: "()", with: "") : nil,
            showLineNumber ? "#\(line)" : nil
        ]
        
        //Join the non-nil strings into a log prefix, and output the final line to the console
        print("\((detailStrings.compactMap {$0}).joined(separator: " ")) - \(getLoggable(obj))")
    }
    
    //MARK: - Define custom methods for logging different types
    private func getLoggable(_ obj: Any) -> String {
        if let s = obj as? String { return s }
        if let e = obj as? Error { return e.localizedDescription }
        return "\(obj)"
    }
}

import Foundation

let log = Logger.shared

/// https://github.com/apple/swift-log/blob/master/Sources/Logging/Logging.swift
final class Logger {
  fileprivate static let shared = Logger()
  private let log = SwiftLog.self
  fileprivate init() {}
  
  @inlinable
  func trace(_ message: @autoclosure () -> Logger.Message,
             metadata: @autoclosure () -> Logger.Metadata? = nil,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    log.verbose(message(), file, function, line: Int(line), context: "TRACE")
  }
  
  @inlinable
  func debug(_ message: @autoclosure () -> Logger.Message,
             metadata: @autoclosure () -> Logger.Metadata? = nil,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    log.debug(message(), file, function, line: Int(line))
  }
  
  @inlinable
  func info(_ message: @autoclosure () -> Logger.Message,
            metadata: @autoclosure () -> Logger.Metadata? = nil,
            file: String = #file,
            function: String = #function,
            line: UInt = #line) {
    log.info(message(), file, function, line: Int(line))
  }
  
  @inlinable
  func notice(_ message: @autoclosure () -> Logger.Message,
              metadata: @autoclosure () -> Logger.Metadata? = nil,
              file: String = #file,
              function: String = #function,
              line: UInt = #line) {
    log.warning(message(), file, function, line: Int(line), context: "NOTICE")
  }
  
  @inlinable
  func warning(_ message: @autoclosure () -> Logger.Message,
               metadata: @autoclosure () -> Logger.Metadata? = nil,
               file: String = #file,
               function: String = #function,
               line: UInt = #line) {
    log.warning(message(), file, function, line: Int(line))
  }
  
  @inlinable
  func error(_ message: @autoclosure () -> Logger.Message,
             metadata: @autoclosure () -> Logger.Metadata? = nil,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    log.error(message(), file, function, line: Int(line))
  }
  
  @inlinable
  func critical(_ message: @autoclosure () -> Logger.Message,
                metadata: @autoclosure () -> Logger.Metadata? = nil,
                file: String = #file,
                function: String = #function,
                line: UInt = #line) {
    log.warning(message(), file, function, line: Int(line), context: "CRITICAL")
  }
  
  
}

extension Logger {
}

extension Logger {
  typealias Message = Any
  typealias Metadata = [String:Any]
}

fileprivate class SwiftLog {
  /// log something generally unimportant (lowest priority)
  open class func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any = "") {
    print("SWIFTLOG:VERBOSE",message(),function,file,line,context)
  }
  
  /// log something which help during debugging (low priority)
  open class func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any = "") {
    print("SWIFTLOG:DEBUG",message(),function,file,line,context)
  }
  
  /// log something which you are really interested but which is not an issue or error (normal priority)
  open class func info(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any = "") {
    print("SWIFTLOG:INFO",message(),function,file,line,context)
  }
  
  /// log something which may cause big trouble soon (high priority)
  open class func warning(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any = "") {
    print("SWIFTLOG:WARNING",message(),function,file,line,context)
  }
  
  /// log something which will keep you awake at night (highest priority)
  open class func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any = "") {
    print("SWIFTLOG:ERROR",message(),function,file,line,context)
  }
}

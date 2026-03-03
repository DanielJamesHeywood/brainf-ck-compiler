import System

@available(macOS, introduced: 11.0)
@inlinable public func print(
    _ items: Any...,
    to file: FileDescriptor,
    separator: String = " ",
    terminator: String = "\n"
) {
    let string = items.map { item in "\(item)" } .joined(separator: separator) + terminator
    try! file.writeAll(string.utf8)
}

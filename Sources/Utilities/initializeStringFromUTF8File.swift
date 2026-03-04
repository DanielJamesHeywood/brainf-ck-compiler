import System

extension String {
    
    @inlinable public init(utf8ContentsOf file: FileDescriptor, expectedByteCount: Int = 4 * 1024) throws {
        var codeUnits = [] as [UInt8]
        try withUnsafeTemporaryAllocation(byteCount: expectedByteCount, alignment: 1) { buffer in
            var hasReadZeroBytes = false
            while !hasReadZeroBytes {
                let bytesRead = try file.read(into: buffer)
                if bytesRead == 0 {
                    hasReadZeroBytes = true
                } else {
                    codeUnits.append(contentsOf: buffer.prefix(bytesRead))
                }
            }
        }
        self.init(copying: try UTF8Span(validating: codeUnits.span))
    }
    
    @inlinable public init(utf8ContentsOfFileAt path: FilePath, expectedByteCount: Int = 4 * 1024) throws {
        let file = try FileDescriptor.open(path, .readOnly)
        self = try file.closeAfter { try String(utf8ContentsOf: file, expectedByteCount: expectedByteCount) }
    }
}

import Darwin

public enum ExitCode {
case success
case failure
}

@inlinable
public func exit(with code: ExitCode) -> Never {
    switch code {
    case .success:
        exit(EXIT_SUCCESS)
    case .failure:
        exit(EXIT_FAILURE)
    }
}

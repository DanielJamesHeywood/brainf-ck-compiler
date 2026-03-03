import Darwin

exit(with: .failure)

enum ExitCode {
case success
case failure
}

func exit(with code: ExitCode) -> Never {
    switch code {
    case .success:
        exit(EXIT_SUCCESS)
    case .failure:
        exit(EXIT_FAILURE)
    }
}

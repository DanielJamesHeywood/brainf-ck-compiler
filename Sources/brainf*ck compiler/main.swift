import Utilities

guard CommandLine.arguments.count == 2 else {
    print(
        "Expected exactly 1 argument, but got \(CommandLine.arguments.count - 1)",
        to: .standardError
    )
    exit(with: .failure)
}
exit(with: .failure)

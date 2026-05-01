# Server Comparison: Node.js vs Dart

This experiment compares a basic HTTP server implementation in JavaScript (Node.js) and Dart.

## Node.js Implementation (`server.js`)
- Uses the built-in `http` module.
- Callback-based structure for handling requests.
- Single-threaded event loop by default.

## Dart Implementation (`server.dart`)
- Uses `dart:io` library.
- Asynchronous `await` for binding the server.
- Stream-based handling of requests (`await for`).
- Strongly typed and compiled (JIT/AOT).

## Key Differences
1. **Concurrency**: Node.js uses callbacks/promises; Dart uses Streams and async/await natively.
2. **Type Safety**: Dart provides strong typing which helps in larger server applications.
3. **Performance**: Dart's AOT compilation can provide faster startup and execution in many scenarios compared to V8's JIT.

print("Hello, world!")

import Foundation

import ArgumentParser

struct Outsource: ParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   init() { }

   mutating func run() throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      let start = Date()

      stepOne()
      stepTwo()

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")

   }

   private func stepOne() {
      let output = executeCommand(command: "/bin/zsh", args: ["-c", " exec tr , '\n' < \(stopWordsFile) > stopwords.txt"])
      print("\(output)")
   }

   private func stepTwo() {
      let output = executeCommand(command: "/bin/zsh", args: ["-c" , "grep -f stopwords.txt \(bookFile) | grep -o '[A-Za-z][A-Za-z][A-Za-z]*' | tr '[:upper:]' '[:lower:]'\\ | sort | uniq -c | sort -rn | head -n \(topListSize) | sed -e 's/ˆ *\\([0-9]*\\) *\\([a-z]*\\)/\\2 - \\1/'"])
      print("\(output)")
   }

   private func executeCommand(command: String, args: [String]) -> String {
      let task = Process()
      task.launchPath = command
      task.arguments = args
      let pipe = Pipe()

      task.standardOutput = pipe
      task.launch()

      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      let output: String = String(decoding: data, as: UTF8.self)
      return output
   }

}

Outsource.main()

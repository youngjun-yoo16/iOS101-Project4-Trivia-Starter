//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Youngjun Yoo on 3/15/24.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestion(amount: Int,
                              type: String,
                              completion: (([TriviaQuestion]) -> Void)? = nil) {
        let parameters = "amount=\(amount)" + (type == "any" ? "" : "&type=\(type)")
        let url = URL(string: "https://opentdb.com/api.php?\(parameters)")!
        // create a data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // this closure is fired when the response is received
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(QuestionAPIResponse.self, from: data)
            DispatchQueue.main.async {
                completion?(response.triviaQuestion)
            }
        }
        task.resume() // resume the task and fire the request
    }
    
    /*private static func parse(data: Data) -> TriviaQuestion {
        // transform the data we received into a dictionary [String: Any]
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let results = jsonDictionary["results"] as! [String: Any]
        // question category
        let category = results["category"] as! String
        // question
        let question = results["question"] as! String
        // correct answer
        let correctAnswer = results["correct_answer"] as! String
        // incorrect answers
        let incorrectAnswers = results["incorrect_answers"] as! [String]
        return TriviaQuestion(category: category,
                                      question: question,
                                      correctAnswer: correctAnswer,
                                      incorrectAnswers: incorrectAnswers)
    }*/
}

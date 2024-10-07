import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate{

    
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        print ("загрузка view did load")
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    //  let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory.loadData() // questionFactory?.loadData()
        
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        print ("нажали да")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        print ("нажали нет")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        print ("следующий вопрос")
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        print ("создание вопроса для показа из фабрики вопросов")
        //let questionStep = QuizStepViewModel(
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        //return questionStep
    }
    
    
    
    
    private func show(quiz step: QuizStepViewModel) {
        print ("показ вопроса ")
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        print ("показ результата ответа на вопрос цветом рамки ")
        
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        print ("задержка")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        print ("показ следующего вопроса или алерта")
        
        guard let statistic = statisticService else {return}
        print ("количество квизов\(statistic.gamesCount)")
        print ("_______ \(statistic.bestGame.correct)")
        
        //statistic.bestGame = GameResult(correct: 0, total: 0, date: Date())
        
        if currentQuestionIndex == questionAmount - 1 {
            print ("показать нужно тут аллерт и где он ??????")
            statistic.store(correct: correctAnswers, total: questionAmount)
            let alertM = AlertModel (title: "Этот раунд окончен!",
                                     message: "Ваш результат \(correctAnswers)/10 \n Количество сыгранных квизов: \(statistic.gamesCount) \n Рекорд:\(statistic.bestGame.correct)/\(statistic.bestGame.total) (\(statistic.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", (statistic.totalAccuracy)))%",
                                     
                                     buttonText: "Сыграть еще раз") {
            }
            alertPresenter?.alertEnd(alend: alertM)
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        } else {
            currentQuestionIndex += 1
            print ("показ index = \(currentQuestionIndex)")
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()   
        
        let alertIndicator = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.alertEnd(alend: alertIndicator) //alertPresenter.show(in: self, model: model) //////
    }
    
    func didLoadDataFromServer() {
         activityIndicator.isHidden = true 
         questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
}

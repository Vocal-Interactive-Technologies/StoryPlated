import Foundation
import Combine
import AVFoundation

@MainActor
class CookingSessionViewModel: ObservableObject {
    @Published var currentStep: RecipeStep?
    @Published var isPlaying = false
    @Published var currentInstruction: String = ""
    @Published var error: Error?
    @Published var isListening = false
    
    private let recipe: Recipe
    private var currentStepIndex = 0
    private var audioPlayer: AVAudioPlayer?
    private let speechService: SpeechRecognitionService
    private var cancellables = Set<AnyCancellable>()
    
    init(recipe: Recipe, speechService: SpeechRecognitionService? = nil) {
        self.recipe = recipe
        self.speechService = speechService ?? SpeechRecognitionService()
        self.currentStep = recipe.steps.first
        
        setupSpeechRecognition()
    }
    
    private func setupSpeechRecognition() {
        // Observe recognized commands
        speechService.$recognizedCommand
            .compactMap { $0 }
            .sink { [weak self] command in
                self?.handleVoiceCommand(command)
            }
            .store(in: &cancellables)
        
        // Observe listening state
        speechService.$isListening
            .assign(to: \.isListening, on: self)
            .store(in: &cancellables)
        
        // Observe errors
        speechService.$error
            .compactMap { $0 }
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    func startSession() {
        playCurrentStep()
        startListening()
    }
    
    func stopSession() {
        stopListening()
        pausePlayback()
    }
    
    func nextStep() {
        guard currentStepIndex < recipe.steps.count - 1 else { return }
        currentStepIndex += 1
        currentStep = recipe.steps[currentStepIndex]
        playCurrentStep()
    }
    
    func previousStep() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
        currentStep = recipe.steps[currentStepIndex]
        playCurrentStep()
    }
    
    func repeatCurrentStep() {
        playCurrentStep()
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumePlayback() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    private func playCurrentStep() {
        // TODO: Implement actual TTS playback
        // For now, just update the instruction text
        currentInstruction = currentStep?.instruction ?? ""
        isPlaying = true
    }
    
    func handleVoiceCommand(_ command: String) {
        switch command.lowercased() {
        case "next":
            nextStep()
        case "previous":
            previousStep()
        case "repeat":
            repeatCurrentStep()
        case "pause":
            pausePlayback()
        case "resume":
            resumePlayback()
        default:
            break
        }
    }
    
    func startListening() {
        speechService.startListening()
    }
    
    func stopListening() {
        speechService.stopListening()
    }
    
    func askQuestion(_ question: String) async throws -> String {
        // TODO: Implement actual Q&A API call
        // For now, return a mock response
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "I'm \(recipe.character.name), and I'd be happy to help you with that! \(question)"
    }
} 

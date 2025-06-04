import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechRecognitionService: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var recognizedCommand: String?
    @Published var error: Error?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var silenceTimer: Timer?
    private let silenceTimeout: TimeInterval = 2.0
    
    override init() {
        super.init()
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied:
                    self?.error = NSError(domain: "SpeechRecognition", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech recognition permission denied"])
                case .restricted:
                    self?.error = NSError(domain: "SpeechRecognition", code: 2, userInfo: [NSLocalizedDescriptionKey: "Speech recognition restricted on this device"])
                case .notDetermined:
                    self?.error = NSError(domain: "SpeechRecognition", code: 3, userInfo: [NSLocalizedDescriptionKey: "Speech recognition not yet authorized"])
                @unknown default:
                    self?.error = NSError(domain: "SpeechRecognition", code: 4, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"])
                }
            }
        }
    }
    
    private func handleSpeechRecognitionError(_ error: Error) {
        let nsError = error as NSError
        
        // Handle specific error cases
        if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1101 {
            self.error = NSError(domain: "SpeechRecognition",
                               code: 1101,
                               userInfo: [NSLocalizedDescriptionKey: "Local speech recognition service is unavailable. Please check your system settings and ensure speech recognition is enabled in System Preferences > Security & Privacy > Privacy > Speech Recognition."])
        } else if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 203 {
            self.error = NSError(domain: "SpeechRecognition",
                               code: 203,
                               userInfo: [NSLocalizedDescriptionKey: "No speech detected. Please speak clearly and ensure your microphone is working properly."])
        } else {
            self.error = error
        }
        stopListening()
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceTimeout, repeats: false) { [weak self] _ in
            self?.handleSpeechRecognitionError(NSError(domain: "SpeechRecognition",
                                                     code: 203,
                                                     userInfo: [NSLocalizedDescriptionKey: "No speech detected. Please speak clearly and ensure your microphone is working properly."]))
        }
    }
    
    func startListening() {
        guard !isListening else { return }
        
        // Reset state
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            handleSpeechRecognitionError(error)
            return
        }
        
        // Create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            self.error = NSError(domain: "SpeechRecognition", code: 5, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"])
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure the microphone input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
            resetSilenceTimer()
        } catch {
            handleSpeechRecognitionError(error)
            return
        }
        
        // Start the recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleSpeechRecognitionError(error)
                return
            }
            
            if let result = result {
                let command = result.bestTranscription.formattedString.lowercased()
                if !command.isEmpty {
                    self.recognizedCommand = command
                    self.resetSilenceTimer()
                    
                    // Check for specific commands
                    if ["next", "previous", "repeat", "pause", "resume"].contains(command) {
                        self.stopListening()
                    }
                }
            }
        }
    }
    
    func stopListening() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        isListening = false
        recognitionRequest = nil
        recognitionTask = nil
    }
} 
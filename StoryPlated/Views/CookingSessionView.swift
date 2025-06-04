import SwiftUI

struct CookingSessionView: View {
    let recipe: Recipe
    @StateObject private var viewModel: CookingSessionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingQuestionSheet = false
    @State private var question = ""
    @State private var answer = ""
    @State private var isAskingQuestion = false
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _viewModel = StateObject(wrappedValue: {
            let builder = { @MainActor in
                let viewModel = CookingSessionViewModel(recipe: recipe)
                viewModel.startSession()
                return viewModel
            }
            return builder()
        }())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: { 
                    viewModel.stopSession()
                    dismiss() 
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("Step \(viewModel.currentStep?.order ?? 0) of \(recipe.steps.count)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showingQuestionSheet = true }) {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                }
            }
            .padding()
            
            // Character Info
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(String(recipe.character.name.prefix(1)))
                            .font(.title)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading) {
                    Text(recipe.character.name)
                        .font(.title3)
                        .bold()
                    
                    Text(recipe.character.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Current Step
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.currentInstruction)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    
                    if let duration = viewModel.currentStep?.duration {
                        HStack {
                            Image(systemName: "clock")
                            Text("Estimated time: \(Int(duration / 60)) minutes")
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            
            // Controls
            HStack(spacing: 30) {
                Button(action: { viewModel.previousStep() }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.pausePlayback()
                    } else {
                        viewModel.resumePlayback()
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                }
                
                Button(action: { viewModel.nextStep() }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .padding()
            
            // Voice Command Status
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: viewModel.isListening ? "waveform.circle.fill" : "waveform.circle")
                        .foregroundColor(viewModel.isListening ? .blue : .gray)
                    Text(viewModel.isListening ? "Listening..." : "Voice Commands")
                        .font(.headline)
                }
                
                Text("Say: next, previous, repeat, pause, resume")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
        .sheet(isPresented: $showingQuestionSheet) {
            NavigationView {
                VStack(spacing: 20) {
                    TextField("Ask your question...", text: $question)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    if isAskingQuestion {
                        ProgressView()
                    } else if !answer.isEmpty {
                        Text(answer)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .navigationTitle("Ask \(recipe.character.name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingQuestionSheet = false
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Ask") {
                            Task {
                                isAskingQuestion = true
                                do {
                                    answer = try await viewModel.askQuestion(question)
                                } catch {
                                    answer = "Sorry, I couldn't process your question."
                                }
                                isAskingQuestion = false
                            }
                        }
                        .disabled(question.isEmpty || isAskingQuestion)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
} 
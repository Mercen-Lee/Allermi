/// Main View Interface
/// Created by Mercen on 2022/11/03.

import SwiftUI
import SwiftUIX
import RealmSwift
import AVKit

// MARK: - Main View
struct MainView: View {
    
    /// State Variables
    @State private var keyboardState: Bool = false
    @State private var focusState: Bool = false
    @State private var settings: Bool = false
    @State private var information: Bool = false
    @State private var typedText: String = String()
    @State private var searchText: String = String()
    
    /// Local Variables
    private var searchState: Bool {
        return !searchText.isEmpty
    }
    private var player = AVPlayer()
    
    /// Local Functions
    private func changeFocusState(_ value: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.default) {
                focusState = value
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !settings {
                // MARK: - Logo
                if !searchState {
                    Spacer()
                    Image("WhiteLogo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .frame(width: 230)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .top)
                            .combined(with: .opacity))
                }
                
                // MARK: - Text Input
                ZStack {
                    
                    /// Placeholder
                    if typedText.isEmpty && !searchState && !focusState {
                        Text("식품명을 입력해 검색하세요")
                            .foregroundColor(.gray)
                    }
                    
                    /// Text Container
                    HStack {
                        
                        if !searchState {
                            Spacer()
                        }
                        
                        /// Text Field
                        CocoaTextField("", text: $typedText, onEditingChanged: { editingChanged in
                            if focusState {
                                changeFocusState(editingChanged)
                            } else {
                                focusState = editingChanged
                            }
                        }, onCommit: {
                            keyboardState = false
                            if !typedText.isEmpty {
                                withAnimation(springAnimation) {
                                    searchText = typedText
                                }
                            }
                        })
                        .isFirstResponder(keyboardState)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                        Spacer()
                        
                        /// Erase Button
                        if !typedText.isEmpty {
                            Button(action: {
                                if player.currentItem != nil {
                                    player.replaceCurrentItem(with: nil)
                                }
                                touch()
                                keyboardState = false
                                focusState = true
                                changeFocusState(false)
                                withAnimation(springAnimation) {
                                    typedText = String()
                                    searchText = String()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: searchState ? .infinity : 500)
                    .background(Color.gray.opacity(0.2)
                        .clipShape(RoundedRectangle(cornerRadius: searchState ? 0 : 20))
                        .ignoresSafeArea(edges: .top))
                    .keyboardType(.webSearch)
                }
                .transition(.move(edge: .top)
                    .combined(with: .opacity))
                .onTapGesture {
                    keyboardState = true
                }
            }
            
            // MARK: - Developers Easter Egg
            if searchState {
                if searchText.uppercased() == "DEVELOPERS" {
                    VideoPlayer(player: player)
                        .onAppear {
                            if player.currentItem == nil {
                                let item = AVPlayerItem(url: Bundle.main.url(forResource: "Developers",
                                                                             withExtension: "mp4")!)
                                player.replaceCurrentItem(with: item)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                player.play()
                            }
                        }
                        .scaledToFit()
                        .frame(maxHeight: .infinity)
                        .disabled(true)
                } else {
                    SearchView(searchText: searchText)
                        .transition(.move(edge: .bottom)
                            .combined(with: .opacity))
                        .ignoresSafeArea(.keyboard)
                        .onAppear {
                            if player.currentItem != nil {
                                player.replaceCurrentItem(with: nil)
                            }
                        }
                }
            }
            
            // MARK: - Settings
            else {
                Spacer()
                ZStack {
                    if settings {
                        SelectionView(selection: $settings, information: $information)
                            .transition(.move(edge: .bottom)
                                .combined(with: .opacity))
                    }
                    
                    // MARK: - Settings Button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                touch()
                                endTextEditing()
                                keyboardState = false
                                withAnimation(springAnimation) {
                                    settings.toggle()
                                }
                            }) {
                                Image(systemName: settings ? "xmark" : "gearshape.fill")
                                    .font(Font.title.weight(.medium))
                                    .foregroundColor(.accentColor)
                                    .rotationEffect(.degrees(settings ? 90 : 0))
                            }
                            .scaleButton()
                        }
                        
                        /// Sending button to top
                        if settings {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(searchState ? 0 : 30)
        .background(Color(.systemBackground).ignoresSafeArea())
        .customModal($information)
        .onTapGesture {
            endTextEditing()
            keyboardState = false
        }
    }
}

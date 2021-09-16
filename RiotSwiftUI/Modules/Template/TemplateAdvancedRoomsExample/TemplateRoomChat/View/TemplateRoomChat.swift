//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14.0, *)
struct TemplateRoomChat: View {
    
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    // MARK: Public
    
    @ObservedObject var viewModel: TemplateRoomChatViewModel.Context
    
    var body: some View {
        VStack {
            if viewModel.viewState.bubbles.isEmpty {
                VStack{
                    Text("No messages")
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader { reader in
                    ScrollView{
                        LazyVStack {
                            ForEach(viewModel.viewState.bubbles) { bubble in
                                TemplateRoomChatBubbleView(bubble: bubble)
                                    .id(bubble.id)
                            }
                        }
                        .onAppear {
                            // Start at the bottom
                            reader.scrollTo(viewModel.viewState.bubbles.last?.id, anchor: .bottom)
                        }
                        .onChange(of: itemCount) { _ in
                            // When new items are added animate to the new items
                            withAnimation {
                                reader.scrollTo(viewModel.viewState.bubbles.last?.id, anchor: .bottom)
                            }
                        }
                        // When the scroll content takes less than the screen space align at the top
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            
            HStack {
                TextField(VectorL10n.roomMessageShortPlaceholder, text: $viewModel.messageInput)
                    .textFieldStyle(BorderedInputFieldStyle())
                if viewModel.viewState.sendButtonEnabled {
                    Button(action: {
                        viewModel.send(viewAction: .sendMessage)
                    }, label: {
                        Image(uiImage: Asset.Images.sendIcon.image)
                    })
                }
            }
            // When displaying/hiding the send button slide it on/off from the right side
            .animation(.easeOut(duration: 0.25))
            .transition(.move(edge: .trailing))
            .padding(.horizontal)
            
        }
        .navigationTitle(viewModel.viewState.roomName ?? "Chat")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(VectorL10n.done) {
                    viewModel.send(viewAction: .cancel)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(VectorL10n.cancel) {
                    viewModel.send(viewAction: .cancel)
                }
            }
        }
    }
    
    private var itemCount: Int {
        return viewModel.viewState
            .bubbles
            .map(\.items)
            .map(\.count)
            .reduce(0, +)
    }
}

// MARK: - Previews

@available(iOS 14.0, *)
struct TemplateRoomChat_Previews: PreviewProvider {
    static var previews: some View {
        MockTemplateRoomChatScreenState.screenGroup(addNavigation: true)
    }
}

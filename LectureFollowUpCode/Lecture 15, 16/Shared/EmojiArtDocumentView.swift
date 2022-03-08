//
//  ContentView.swift
//  EmojiArt
//
//  Created by Kihun SONG on 2022/02/11.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    // L14 get our UndoManager from our @Environment
    // L14 we then pass it into all the Intent functions we call
    // L14 since our ViewModel is the one who actually implements undo
    @Environment(\.undoManager) var undoManager
    
    // L14 scale the size of the emojis in our palette to the user's font size preference
    @ScaledMetric var defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser(emojiFontSize: defaultEmojiFontSize)
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                // L15 don't need this as an .overlay anymore
                // L15 we explicitly position it in the ZStack
                OptionalImage(uiImage: document.backgroundImage)
                    .scaleEffect(zoomScale)
                    .position(convertFromEmojiCoordinates((0,0), in: geometry))
                .gesture(doubleTapToZoom(in: geometry.size))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.utf8PlainText, .url, .image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
            .alert(item: $alertToShow) { alertToShow in
                // return Alert
                alertToShow.alert()
            }
            // L12 monitor fetch status and alert user if fetch failed
            .onChange(of: document.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    showBackgroundImageFetchFailedAlert(url)
                default:
                    break
                }
            }
            .onReceive(document.$backgroundImage) { image in
                if autozoom { // L14 only "auto zoom" when drag and drop happens
                    zoomToFit(image, in: geometry.size)
                }
            }
            // L14 simple undo UI just to demonstrate undo working
            // L14 see UndoButton in UtilityViews.swift
            // L15 added background-setting and undo/redo operations to the navigation toolbar
            // L15 but since only one button can appear there in .compact horizontal settings
            // L15 we use .compactableToolbar to turn it into a single button with context menu in that case
            .compactableToolbar {
                // L15 add background-setting via pasteboard
                // L15 especially useful on iPhone since no drag-and-drop there
                AnimatedActionButton(title: "Paste Background", systemImage: "doc.on.clipboard") {
                    pasteBackground()
                }
                // L15 add background-setting via taking a photo with the camera
                if Camera.isAvailable {
                    AnimatedActionButton(title: "Take Photo", systemImage: "camera") {
                        backgroundPicker = .camera
                    }
                }
                // L15 add background-setting by choosing a photo from the user's photo library
                if PhotoLibrary.isAvailable {
                    AnimatedActionButton(title: "Search Photos", systemImage: "photo") {
                        backgroundPicker = .library
                    }
                }
                // L15 unrolled undo and redo from context menu into toolbar
                // L16 don't need undo and redo buttons on macOS because we have an Edit menu
                #if os(iOS)
                if let undoManager = undoManager {
                    if undoManager.canUndo {
                        AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.backward") {
                            undoManager.undo()
                        }
                    }
                    if undoManager.canRedo {
                        AnimatedActionButton(title: undoManager.redoActionName, systemImage: "arrow.uturn.forward") {
                            undoManager.redo()
                        }
                    }
                }
                #endif
            }
            // L15 puts up a sheet to show either the camera or photo library
            // L15 see Camera.swift and PhotoLibrary.swift
            .sheet(item: $backgroundPicker) { pickerType in
                switch pickerType {
                case .camera: Camera(handlePickedImage: { image in handlePickedBackgroundImage(image) })
                case .library: PhotoLibrary(handlePickedImage: { image in handlePickedBackgroundImage(image)})
                }
            }
        }
    }
    
    // L15 handler for an image from camera or photo library
    private func handlePickedBackgroundImage(_ image: UIImage?) {
        autozoom = true
        if let imageData = image?.imageData {
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        }
        backgroundPicker = nil
    }
    
    // L15 @State which controls whether the camera or photo-library sheet (or neither) is up
    @State private var backgroundPicker: BackgroundPickerType?
    
    // L15 enum to control which photo-picking sheet to show
    enum BackgroundPickerType: Identifiable {
        case camera
        case library
        var id: BackgroundPickerType { self }
    }
    
    // L15 set the background from whatever's in the pasteboard
    private func pasteBackground() {
        autozoom = true
        if let imageData = Pasteboard.imageData { // L16 made cross-platform
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        } else if let url = Pasteboard.imageURL { // L16 made cross-platform
            document.setBackground(.url(url), undoManager: undoManager)
        } else {
            alertToShow = IdentifiableAlert(
                title: "Paste Background",
                message: "There is no image currently on the pasteboard."
            )
        }
    }
    
    // L14 only "auto zoom" when drag and drop happens
    // L14 so that @SceneStorage can restore our zoom/pan settings
    @State private var autozoom = false
    
    // L12 state which says whether a certain identifiable alert should be showing
    @State private var alertToShow: IdentifiableAlert?
    
    // L12 sets alertToShow to an IdentifiableAlert explaining a url fetch failure
    private func showBackgroundImageFetchFailedAlert(_ url: URL) {
        alertToShow = IdentifiableAlert(id: "fetch failed: " + url.absoluteString, alert: {
            Alert(title: Text("Background Image Fetch"),
                  message: Text("Couldn't load image from \(url)."),
                  dismissButton: .default(Text("OK"))
            )
        })
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            autozoom = true // L14 only "auto zoom" when drag and drop happens
            // L14 pass undo manager to Intent functions
            document.setBackground(.url(url.imageURL), undoManager: undoManager)
        }
        // L16 NSImage does not have an NSItemProvider
        // L16 TODO: figure out a way to drop an NSImage on macOS?
        // L16 (still doable via URL code above for now)
        #if os(iOS)
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    autozoom = true // L14 only "auto zoom" when drag and drop happens
                    // L14 pass undo manager to Intent functions
                    document.setBackground(.imageData(data), undoManager: undoManager)
                }
            }
        }
        #endif
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(String(emoji),
                                      at: convertToEmojiCoordinates(location, in: geometry),
                                      size: defaultEmojiFontSize / zoomScale,
                                      // L14 pass undo manager to Intent functions
                                      undoManager: undoManager)
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - center.x) / zoomScale,
            y: (location.y - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int),
                                             in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint (
            x: center.x + CGFloat(location.x) * zoomScale,
            y: center.y + CGFloat(location.y) * zoomScale
        )
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    // MARK: - Panning

    // L14 remember our pan position on a per-scene basis
    @SceneStorage("EmojiArtDocumentView.steadyStatePanOffset")
    private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        // normally we can not add CGSize
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    // MARK: - Zooming
    
    // L14 remember our zoom scale on a per-scene basis
    @SceneStorage("EmojiArtDocumentView.steadyStateZoomScale")
    private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}

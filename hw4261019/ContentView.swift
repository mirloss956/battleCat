import SwiftUI
import ImageIO

// MARK: - 角色與型態資料

struct CatForm {
    let name: String
    let gifName: String          // 改：原本的 emoji 換成 GIF 檔名（不含 .gif）
    let description: String
    let attackDescription: String
}

struct CatCharacter: Identifiable {
    let id: Int
    let lv1: CatForm
    let lv10: CatForm
    let lv30: CatForm

    func form(for stage: String) -> CatForm {
        switch stage {
        case "Lv10": return lv10
        case "Lv30": return lv30
        default: return lv1
        }
    }
}

struct ContentView: View {

    // MARK: 狀態管理

    @State private var selectedCategory = "Lv1"
    @State private var currentPage = 0

    let categories = ["Lv1", "Lv10", "Lv30"]

    // 切換階段 (Lv1 / Lv10 / Lv30)
    func changeStage(to stage: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedCategory = stage
        }
    }

    // 切換到指定的貓
    func changeCat(to page: Int) {
        guard !characters.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPage = (page + characters.count) % characters.count
            selectedCategory = "Lv1"
        }
    }

    // 每隻貓咪在 Lv1、Lv10、Lv30 都有專屬的進化型態與名稱
    // gifName 先暫用 cat1_lv1 這類名稱，之後可自行改成實際檔名
    // （基本貓 Lv1 先沿用你現有的 animation.gif，方便立刻測試）
    private let characters: [CatCharacter] = [
        CatCharacter(
            id: 0,
            lv1: CatForm(
                name: "基本貓",
                gifName: "animation",
                description: "可以快速生產的基本角色",
                attackDescription: "攻擊方式：近距離攻擊"
            ),
            lv10: CatForm(
                name: "肌肉貓",
                gifName: "cat1_lv10",
                description: "鍛鍊出結實肌肉的進階貓咪",
                attackDescription: "攻擊方式：強力近距離攻擊"
            ),
            lv30: CatForm(
                name: "摩西根貓",
                gifName: "cat1_lv30",
                description: "體格鍛鍊到極致並留著狂野龐克頭",
                attackDescription: "攻擊方式：超破壞近距離攻擊"
            )
        ),
        CatCharacter(
            id: 1,
            lv1: CatForm(
                name: "長腿貓",
                gifName: "cat2_lv1",
                description: "擁有較長攻擊距離的角色",
                attackDescription: "攻擊方式：遠距離攻擊"
            ),
            lv10: CatForm(
                name: "美腿貓",
                gifName: "cat2_lv10",
                description: "腿部線條更加修長的美腿角色",
                attackDescription: "攻擊方式：廣範圍遠距離攻擊"
            ),
            lv30: CatForm(
                name: "狂亂美腿貓",
                gifName: "cat2_lv30",
                description: "腿力超越常理的終極美腿貓",
                attackDescription: "攻擊方式：超遠距離衝擊波"
            )
        ),
        CatCharacter(
            id: 2,
            lv1: CatForm(
                name: "牆貓",
                gifName: "cat3_lv1",
                description: "適合用來抵擋敵人的肉盾角色",
                attackDescription: "攻擊方式：防禦與阻擋"
            ),
            lv10: CatForm(
                name: "橡皮貓",
                gifName: "cat3_lv10",
                description: "如橡皮擦般方正堅固的防禦專家",
                attackDescription: "攻擊方式：超高體力防禦阻擋"
            ),
            lv30: CatForm(
                name: "狂亂牆貓",
                gifName: "cat3_lv30",
                description: "化身為不可撼動的鋼鐵要塞",
                attackDescription: "攻擊方式：絕對防禦力護盾"
            )
        )
    ]

    private var currentCat: CatCharacter {
        guard !characters.isEmpty else {
            return characters[0]
        }
        let safeIndex = min(max(0, currentPage), characters.count - 1)
        return characters[safeIndex]
    }

    private var currentForm: CatForm {
        currentCat.form(for: selectedCategory)
    }

    // MARK: 主畫面

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 棕色遊戲外框
                Color(red: 0.38, green: 0.19, blue: 0.09)

                VStack(spacing: 8) {
                    // 保留上方深咖啡色裝飾區塊（移除 XP、MENU 與彩色方塊）
                    Rectangle()
                        .fill(Color(red: 0.25, green: 0.13, blue: 0.08))
                        .frame(height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                    gameArea
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, max(36, geometry.size.width * 0.06))
                .padding(.top, max(12, geometry.size.height * 0.035))
                .padding(.bottom, max(16, geometry.size.height * 0.05))
            }
            .ignoresSafeArea()
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .preferredColorScheme(.light)
        .statusBarHidden()
    }

    // MARK: 遊戲主區域

    private var gameArea: some View {
        GeometryReader { geometry in
            ZStack {
                // 藍綠色格線背景
                GridBackground()
                    .overlay {
                        LinearGradient(
                            colors: [
                                .white.opacity(0.06),
                                .clear,
                                .black.opacity(0.06)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }

                VStack(spacing: 4) {
                    // 階段選擇器
                    categorySelector
                        .padding(.horizontal, 10)
                        .padding(.top, 8)

                    Spacer(minLength: 2)

                    // 角色展示與左右按鈕
                    HStack(spacing: 0) {
                        arrowButton(isLeft: true)
                            .frame(width: geometry.size.width * 0.09)

                        Spacer(minLength: 0)

                        characterDisplay

                        Spacer(minLength: 0)

                        arrowButton(isLeft: false)
                            .frame(width: geometry.size.width * 0.09)
                    }
                    .frame(maxHeight: .infinity)

                    // Page Control
                    pageControl
                        .padding(.bottom, 4)

                    // 角色說明面板（保持適當高度與底部留白，不與下方貼齊）
                    descriptionPanel
                        .frame(
                            width: geometry.size.width * 0.58,
                            height: max(58, geometry.size.height * 0.23)
                        )
                        .padding(.bottom, 16)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.black.opacity(0.35), lineWidth: 2)
            }
        }
    }

    // MARK: 階段選擇器 (Lv1 / Lv10 / Lv30)

    private var categorySelector: some View {
        HStack(spacing: 0) {
            ForEach(categories, id: \.self) { stage in
                Button {
                    changeStage(to: stage)
                } label: {
                    Text(stage)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(
                            selectedCategory == stage
                            ? .black
                            : .white
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedCategory == stage
                            ? Color.yellow
                            : Color.clear
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.black.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .frame(maxWidth: 220)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: 角色展示（掛載滑動手勢，避免與其他按鈕互相干擾）

    private var characterDisplay: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 0)

            // 改：Text(emoji) → GIFImage
            GIFImage(name: currentForm.gifName)
                .frame(width: 70, height: 70)
                .shadow(color: .black.opacity(0.15), radius: 2)
                .id("\(currentCat.id)-\(selectedCategory)")
                .transition(.opacity.combined(with: .scale))

            Text(currentForm.name)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 2)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < -40 {
                        changeCat(to: currentPage + 1)
                    } else if value.translation.width > 40 {
                        changeCat(to: currentPage - 1)
                    }
                }
        )
    }

    // MARK: 黃色方向箭頭 Button

    private func arrowButton(isLeft: Bool) -> some View {
        Button {
            if isLeft {
                changeCat(to: currentPage - 1)
            } else {
                changeCat(to: currentPage + 1)
            }
        } label: {
            Image(systemName: "triangle.fill")
                .font(.system(size: 19, weight: .black))
                .foregroundStyle(Color(red: 0.86, green: 0.84, blue: 0.42))
                .rotationEffect(.degrees(isLeft ? -90 : 90))
                .shadow(color: .black.opacity(0.7), radius: 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: Page Control

    private var pageControl: some View {
        HStack(spacing: 7) {
            ForEach(characters.indices, id: \.self) { index in
                Button {
                    changeCat(to: index)
                } label: {
                    Circle()
                        .fill(
                            currentPage == index
                            ? Color.yellow
                            : Color.white.opacity(0.6)
                        )
                        .frame(width: 7, height: 7)
                        .overlay {
                            Circle()
                                .stroke(.black.opacity(0.6), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("第 \(index + 1) 頁")
            }
        }
    }

    // MARK: 黑色角色說明框

    private var descriptionPanel: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("【\(currentForm.name)】")
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white)

            Text(currentForm.description)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)

            Text(currentForm.attackDescription)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.12, blue: 0.12),
                    Color.black.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay {
            Rectangle()
                .stroke(Color.gray.opacity(0.8), lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.3), radius: 2)
    }
}

// MARK: - GIF 播放元件

struct GIFImage: UIViewRepresentable {
    let name: String

    final class Coordinator {
        var currentName: String?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.layer.magnificationFilter = .nearest   // 像素風保持銳利，不需要可移除
        imageView.image = GIFLoader.image(named: name)
        context.coordinator.currentName = name
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // 只有檔名改變才換圖，避免每次刷新畫面都讓動畫重頭播放
        guard context.coordinator.currentName != name else { return }
        uiView.image = GIFLoader.image(named: name)
        context.coordinator.currentName = name
    }
}

enum GIFLoader {
    private static var cache: [String: UIImage] = [:]

    static func image(named name: String) -> UIImage? {
        if let cached = cache[name] { return cached }

        guard
            let url = Bundle.main.url(forResource: name, withExtension: "gif"),
            let data = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData(data as CFData, nil)
        else { return nil }

        var frames: [UIImage] = []
        var totalDuration: Double = 0

        for i in 0..<CGImageSourceGetCount(source) {
            guard let cg = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            frames.append(UIImage(cgImage: cg))

            let props = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any]
            let gif = props?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
            let delay = (gif?[kCGImagePropertyGIFUnclampedDelayTime] as? Double)
                ?? (gif?[kCGImagePropertyGIFDelayTime] as? Double)
                ?? 0.1
            totalDuration += max(delay, 0.02)
        }

        let image = UIImage.animatedImage(with: frames, duration: totalDuration)
        if let image { cache[name] = image }
        return image
    }
}

// MARK: - 格線背景

struct GridBackground: View {
    var body: some View {
        Canvas { context, size in
            let background = Path(
                CGRect(origin: .zero, size: size)
            )

            context.fill(
                background,
                with: .color(Color(red: 0.27, green: 0.70, blue: 0.75))
            )

            var grid = Path()
            let spacing: CGFloat = 14

            stride(from: CGFloat.zero, through: size.width, by: spacing)
                .forEach { x in
                    grid.move(to: CGPoint(x: x, y: 0))
                    grid.addLine(to: CGPoint(x: x, y: size.height))
                }

            stride(from: CGFloat.zero, through: size.height, by: spacing)
                .forEach { y in
                    grid.move(to: CGPoint(x: 0, y: y))
                    grid.addLine(to: CGPoint(x: size.width, y: y))
                }

            context.stroke(
                grid,
                with: .color(Color.white.opacity(0.13)),
                lineWidth: 0.6
            )
        }
    }
}

#Preview {
    ContentView()
}

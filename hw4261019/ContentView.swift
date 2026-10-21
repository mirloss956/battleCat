import SwiftUI

// MARK: - 角色與型態資料

struct CatForm {
    let name: String
    let imageName: String        // PNG 圖片名稱（Assets 中的 Image Set 名稱）
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
    // imageName 為 Assets.xcassets 內的圖片名稱，先暫用 cat1_lv1 這類名稱，之後可自行改成實際名稱
    private let characters: [CatCharacter] = [
        CatCharacter(
            id: 0,
            lv1: CatForm(
                name: "貓咪",
                imageName: "cat1_lv1",
                description: "可以低成本生產的基本角色",
                attackDescription: "攻擊方式：單體攻擊"
            ),
            lv10: CatForm(
                name: "健美貓",
                imageName: "cat1_lv10",
                description: "飽經鍛鍊的肌肉是魅力所在的\n基本角色",
                attackDescription: "攻擊方式：單體攻擊"
            ),
            lv30: CatForm(
                name: "摩西根貓",
                imageName: "cat1_lv30",
                description: "飽經鍛鍊的肌肉跟很MAN的髮型\n是魅力所在的基本角色",
                attackDescription: "攻擊方式：單體攻擊"
            )
        ),
        CatCharacter(
            id: 1,
            lv1: CatForm(
                name: "長腿貓",
                imageName: "cat2_lv1",
                description: "可以攻擊遠處敵人的遠距離攻擊型角色\n只是單發的話攻擊力很高",
                attackDescription: "攻擊方式：單體攻擊"
            ),
            lv10: CatForm(
                name: "美腿貓",
                imageName: "cat2_lv10",
                description: "對自己超美的腿感到驕傲的遠距離攻擊型角色\n只是單發的話攻擊力很高",
                attackDescription: "攻擊方式：單體攻擊"
            ),
            lv30: CatForm(
                name: "筋肉美腿貓",
                imageName: "cat2_lv30",
                description: "對自己健美的腿感到驕傲的遠距離攻擊型角色\n只是單發的話攻擊力很高\n善於攻擊異星戰士",
                attackDescription: "攻擊方式：單體攻擊\n（善於攻擊）"
            )
        ),
        CatCharacter(
            id: 2,
            lv1: CatForm(
                name: "坦克貓",
                imageName: "cat3_lv1",
                description: "體力很強的肉盾角色\n攻擊力跟弱雞差不多（範圍攻擊）",
                attackDescription: "攻擊方式：範圍攻擊"
            ),
            lv10: CatForm(
                name: "牆貓",
                imageName: "cat3_lv10",
                description: "用來當人牆最適合不過的肉盾角色\n攻擊力還是老樣子（範圍攻擊）",
                attackDescription: "攻擊方式：範圍攻擊"
            ),
            lv30: CatForm(
                name: "橡皮貓",
                imageName: "cat3_lv30",
                description: "用來當人牆最適合不過的肉盾角色\n利用橡膠的彈力更加強化\n攻擊力還是老樣子（範圍攻擊）",
                attackDescription: "攻擊方式：範圍攻擊"
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
            let isLandscape = geometry.size.width > geometry.size.height

            ZStack {
                // 棕色遊戲外框
                Color(red: 0.38, green: 0.19, blue: 0.09)

                VStack(spacing: 8) {
                    // 保留上方深咖啡色裝飾區塊（移除 XP、MENU 與彩色方塊）
                    Rectangle()
                        .fill(Color(red: 0.25, green: 0.13, blue: 0.08))
                        .frame(height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                    gameArea(isLandscape: isLandscape)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, isLandscape ? max(36, geometry.size.width * 0.06) : 16)
                .padding(.top, isLandscape ? max(12, geometry.size.height * 0.035) : max(44, geometry.size.height * 0.05))
                .padding(.bottom, isLandscape ? max(16, geometry.size.height * 0.05) : max(24, geometry.size.height * 0.04))
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

    private func gameArea(isLandscape: Bool) -> some View {
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
                            .frame(width: isLandscape ? geometry.size.width * 0.09 : 44)

                        Spacer(minLength: 0)

                        characterDisplay(isLandscape: isLandscape)

                        Spacer(minLength: 0)

                        arrowButton(isLeft: false)
                            .frame(width: isLandscape ? geometry.size.width * 0.09 : 44)
                    }
                    .frame(maxHeight: .infinity)

                    // Page Control
                    pageControl
                        .padding(.bottom, 4)

                    // 角色說明面板（保持適當高度與底部留白，不與下方貼齊）
                    descriptionPanel
                        .frame(
                            width: isLandscape ? geometry.size.width * 0.58 : geometry.size.width * 0.88,
                            height: isLandscape ? max(75, geometry.size.height * 0.26) : 105
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

    private func characterDisplay(isLandscape: Bool) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            Image(currentForm.imageName)
                .resizable()
                .interpolation(.none)          // 像素風保持銳利，不需要可移除
                .scaledToFit()
                .frame(
                    width: isLandscape ? 100 : 130,
                    height: isLandscape ? 100 : 130
                )
                .shadow(color: .black.opacity(0.15), radius: 2)
                .id("\(currentCat.id)-\(selectedCategory)")
                .transition(.opacity.combined(with: .scale))

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
        VStack(alignment: .leading, spacing: 3) {
            Text("【\(currentForm.name)】")
                .font(.system(size: 12.5, weight: .black))
                .foregroundStyle(.white)

            Text(currentForm.description)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(nil)

            Text(currentForm.attackDescription)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(nil)

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

#Preview("橫向", traits: .landscapeLeft) {
    ContentView()
}

#Preview("直向") {
    ContentView()
}

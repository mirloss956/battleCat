
import SwiftUI

struct CatInfo: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let description: String
    let attack: Int
    let cost: Int
}

struct ContentView: View {
    @State private var selectedIndex = 0
    @State private var selectedTab = "角色介紹"
    @State private var favorites: Set<Int> = []

    private let tabs = ["角色介紹", "能力資訊"]

    private let cats = [
        CatInfo(
            id: 0,
            name: "基本貓",
            emoji: "🐈",
            description: "最初的夥伴，陪你踏上冒險旅程！",
            attack: 100,
            cost: 75
        ),
        CatInfo(
            id: 1,
            name: "勇者貓",
            emoji: "⚔️🐈",
            description: "手持武器，勇敢迎戰前方的敵人！",
            attack: 250,
            cost: 150
        ),
        CatInfo(
            id: 2,
            name: "萌萌貓",
            emoji: "😺",
            description: "外表可愛，也是圖鑑裡的收藏夥伴。",
            attack: 180,
            cost: 120
        )
    ]

    private var currentCat: CatInfo {
        cats[selectedIndex]
    }

    private var isFavorite: Bool {
        favorites.contains(currentCat.id)
    }

    var body: some View {
        VStack(spacing: 20) {
            // 頂部標題
            HStack {
                Image(systemName: "book.closed.fill")
                Text("貓咪圖鑑")
                    .font(.title2.bold())

                Spacer()

                Text("收藏 \(favorites.count)")
                    .font(.subheadline.bold())
            }
            .padding(.horizontal)

            // 貓咪展示區
            VStack(spacing: 14) {
                Text(currentCat.emoji)
                    .font(.system(size: 100))
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.blue.opacity(0.12),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedIndex =
                                (selectedIndex + 1) % cats.count
                        }
                    }

                Text(currentCat.name)
                    .font(.title.bold())

                Text("圖鑑編號 No. \(currentCat.id + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // 上一隻與下一隻
                HStack {
                    Button {
                        changeCat(by: -1)
                    } label: {
                        Label("上一隻", systemImage: "chevron.left")
                    }

                    Spacer()

                    Button {
                        changeCat(by: 1)
                    } label: {
                        Label("下一隻", systemImage: "chevron.right")
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            // 分段控制器
            Picker("資訊類別", selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // 依照選取項目顯示內容
            Group {
                if selectedTab == "角色介紹" {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("角色介紹")
                            .font(.headline)

                        Text(currentCat.description)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("能力資訊")
                            .font(.headline)

                        Text("攻擊力：\(currentCat.attack)")
                        Text("出擊費用：\(currentCat.cost)")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                Color.gray.opacity(0.10),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .padding(.horizontal)

            // 收藏按鈕
            Button {
                if isFavorite {
                    favorites.remove(currentCat.id)
                } else {
                    favorites.insert(currentCat.id)
                }
            } label: {
                Label(
                    isFavorite ? "取消收藏" : "收藏這隻貓咪",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { value in
                    if value.translation.width < -40 {
                        changeCat(by: 1)
                    } else if value.translation.width > 40 {
                        changeCat(by: -1)
                    }
                }
        )
    }

    private func changeCat(by offset: Int) {
        withAnimation(.easeInOut) {
            selectedIndex =
                (selectedIndex + offset + cats.count) % cats.count
        }
    }
}

#Preview {
    ContentView()
}

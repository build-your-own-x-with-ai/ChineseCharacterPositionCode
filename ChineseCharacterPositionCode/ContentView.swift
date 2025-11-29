//
//  ContentView.swift
//  ChineseCharacterPositionCode
//
//  Created by i on 2025/11/29.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // GB2312 码表查询页面
            CodeTableView()
                .tabItem {
                    Label(LocalizedStringKey("TAB_CODE_TABLE"), systemImage: "book.fill")
                }
                .tag(0)

            // 使用说明页面
            InstructionsView()
                .tabItem {
                    Label(LocalizedStringKey("TAB_INSTRUCTIONS"), systemImage: "info.circle.fill")
                }
                .tag(1)
        }
    }
}

// GB2312 码表查询视图
struct CodeTableView: View {
    @State private var searchText = ""
    @State private var selectedArea = 16 // 默认选择第16区（常用汉字开始）
    @State private var characters: [CharacterInfo] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                HStack {
                    TextField(LocalizedStringKey("CODE_TABLE_SEARCH_PLACEHOLDER"), text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onChange(of: searchText) { _, newValue in
                            if newValue.count >= 2 {
                                if let area = Int(newValue.prefix(2)), area >= 1 && area <= 94 {
                                    selectedArea = area
                                }
                            }
                        }

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                // 区选择器
                Picker(LocalizedStringKey("CODE_TABLE_AREA_PICKER"), selection: $selectedArea) {
                    ForEach(1...94, id: \.self) { area in
                        Text(String(format: NSLocalizedString("AREA_NUMBER_FORMAT", comment: ""), "\(area)")).tag(area)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedArea) { _, _ in
                    loadCharacters()
                }

                // 字符网格
                if isLoading {
                    ProgressView(LocalizedStringKey("Loading..."))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 80), spacing: 8)
                        ], spacing: 8) {
                            ForEach(filteredCharacters) { charInfo in
                                CharacterCardView(charInfo: charInfo)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("CODE_TABLE_TITLE"))
            .onAppear {
                loadCharacters()
            }
        }
    }

    // 过滤字符
    private var filteredCharacters: [CharacterInfo] {
        if searchText.isEmpty {
            return characters
        }

        // 如果输入了4位数字，精确匹配
        if searchText.count == 4 {
            return characters.filter { $0.code == searchText }
        }

        // 否则按区位码前缀匹配
        return characters.filter { $0.code.hasPrefix(searchText) }
    }

    // 加载字符数据
    private func loadCharacters() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let chars = GB2312Data.shared.getCharactersInArea(selectedArea)
            DispatchQueue.main.async {
                self.characters = chars
                self.isLoading = false
            }
        }
    }
}

// 字符卡片视图
struct CharacterCardView: View {
    let charInfo: CharacterInfo
    @State private var showDetail = false

    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            VStack(spacing: 4) {
                Text(charInfo.character)
                    .font(.system(size: 32))
                    .frame(height: 50)

                Text(charInfo.code)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .alert(LocalizedStringKey("CHARACTER_DETAIL_TITLE"), isPresented: $showDetail) {
            Button(LocalizedStringKey("COPY_POSITION_CODE")) {
                UIPasteboard.general.string = charInfo.code
            }
            Button(LocalizedStringKey("COPY_CHINESE_CHARACTER")) {
                UIPasteboard.general.string = charInfo.character
            }
            Button(LocalizedStringKey("OK"), role: .cancel) {}
        } message: {
            Text("""
            汉字：\(charInfo.character)
            区位码：\(charInfo.code)
            \(charInfo.codeDescription)
            """)
        }
    }
}

// 使用说明视图
struct InstructionsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InstructionSection(
                        title: NSLocalizedString("WHAT_IS_POSITION_CODE", comment: ""),
                        icon: "questionmark.circle.fill",
                        content: """
                        GB2312 区位码是一种汉字输入编码方式，将汉字按照区位进行编码。

                        • 共有 94 个区，每个区 94 个位
                        • 区号范围：01-94
                        • 位号范围：01-94
                        • 输入方式：4 位数字（前2位区号 + 后2位位号）
                        """
                    )

                    InstructionSection(
                        title: NSLocalizedString("HOW_TO_USE_KEYBOARD", comment: ""),
                        icon: "keyboard.fill",
                        content: """
                        1. 在系统设置中添加"区位码输入法"键盘
                        2. 在任意输入框中切换到区位码键盘
                        3. 输入 4 位区位码数字
                        4. 系统自动输入对应汉字

                        示例：
                        • 输入 1601 → 啊
                        • 输入 3021 → 中
                        • 输入 5448 → 国
                        """
                    )

                    InstructionSection(
                        title: NSLocalizedString("HOW_TO_ADD_KEYBOARD", comment: ""),
                        icon: "gear",
                        content: """
                        1. 点击下方按钮跳转到系统设置
                        2. 在键盘列表中点击"添加新键盘..."
                        3. 在第三方键盘列表中找到"区位码"
                        4. 点击添加即可使用

                        提示：添加后在任意输入框中长按"0"按钮可切换键盘
                        """
                    )

                    Button(action: openKeyboardSettings) {
                        HStack {
                            Image(systemName: "keyboard")
                            Text(LocalizedStringKey("OPEN_KEYBOARD_SETTINGS"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top)

                    InstructionSection(
                        title: NSLocalizedString("COMMON_CHARACTERS_REFERENCE", comment: ""),
                        icon: "star.fill",
                        content: """
                        第 16-55 区：一级汉字（按拼音排序）
                        第 56-87 区：二级汉字（按部首排序）
                        第 01-09 区：特殊符号
                        第 10-15 区：数字、字母等
                        """
                    )

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey("TAB_INSTRUCTIONS"))
        }
    }

    private func openKeyboardSettings() {
        // 最后回退到打开主设置页面
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// 说明段落组件
struct InstructionSection: View {
    let title: String
    let icon: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}

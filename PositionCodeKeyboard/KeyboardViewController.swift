//
//  KeyboardViewController.swift
//  PositionCodeKeyboard
//
//  Created by i on 2025/11/29.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    // MARK: - Properties
    private var inputBuffer = "" // 输入缓冲区，存储当前输入的数字
    private var inputLabel: UILabel! // 显示当前输入的区位码
    private var candidateLabel: UILabel! // 显示候选汉字
    private var buttonHeight: CGFloat = 50

    // MARK: - Lifecycle

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardUI()
    }

    // MARK: - UI Setup

    private func setupKeyboardUI() {
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.87, alpha: 1.0)

        // 创建容器视图
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 创建输入显示区域
        let inputDisplayView = createInputDisplayView()
        containerView.addSubview(inputDisplayView)

        // 创建数字键盘
        let keyboardView = createNumberKeyboard()
        containerView.addSubview(keyboardView)

        // 创建功能键区域
        let functionView = createFunctionButtons()
        containerView.addSubview(functionView)

        // 布局约束
        NSLayoutConstraint.activate([
            // 输入显示区域
            inputDisplayView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            inputDisplayView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
            inputDisplayView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            inputDisplayView.heightAnchor.constraint(equalToConstant: 60),

            // 数字键盘
            keyboardView.topAnchor.constraint(equalTo: inputDisplayView.bottomAnchor, constant: 4),
            keyboardView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
            keyboardView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),

            // 功能键
            functionView.topAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: 4),
            functionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
            functionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            functionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            functionView.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }

    // 创建输入显示区域
    private func createInputDisplayView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6

        // 输入码标签
        inputLabel = UILabel()
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.text = "区位码: "
        inputLabel.font = UIFont.systemFont(ofSize: 16)
        inputLabel.textAlignment = .left
        view.addSubview(inputLabel)

        // 候选字标签
        candidateLabel = UILabel()
        candidateLabel.translatesAutoresizingMaskIntoConstraints = false
        candidateLabel.text = ""
        candidateLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        candidateLabel.textAlignment = .center
        view.addSubview(candidateLabel)

        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            inputLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            inputLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),

            candidateLabel.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 4),
            candidateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            candidateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            candidateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        return view
    }

    // 创建数字键盘（1-9）
    private func createNumberKeyboard() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let numbers = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"]
        ]

        var previousRow: UIView?

        for (rowIndex, row) in numbers.enumerated() {
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rowView)

            NSLayoutConstraint.activate([
                rowView.leftAnchor.constraint(equalTo: view.leftAnchor),
                rowView.rightAnchor.constraint(equalTo: view.rightAnchor),
                rowView.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])

            if let prev = previousRow {
                rowView.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 4).isActive = true
            } else {
                rowView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            }

            if rowIndex == numbers.count - 1 {
                rowView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            }

            // 创建行中的按钮
            var previousButton: UIButton?
            for (colIndex, number) in row.enumerated() {
                if number.isEmpty {
                    // 占位空间
                    let spacer = UIView()
                    spacer.translatesAutoresizingMaskIntoConstraints = false
                    rowView.addSubview(spacer)

                    if let prev = previousButton {
                        spacer.leftAnchor.constraint(equalTo: prev.rightAnchor, constant: 4).isActive = true
                    } else {
                        spacer.leftAnchor.constraint(equalTo: rowView.leftAnchor).isActive = true
                    }

                    if colIndex == row.count - 1 {
                        spacer.rightAnchor.constraint(equalTo: rowView.rightAnchor).isActive = true
                    }

                    spacer.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                    spacer.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true

                    if colIndex < row.count - 1 && !row[colIndex + 1].isEmpty {
                        previousButton = nil
                    }
                    continue
                }

                let button = createKeyButton(title: number, action: #selector(numberKeyPressed(_:)))
                rowView.addSubview(button)

                if let prev = previousButton {
                    button.leftAnchor.constraint(equalTo: prev.rightAnchor, constant: 4).isActive = true
                    button.widthAnchor.constraint(equalTo: prev.widthAnchor).isActive = true
                } else {
                    button.leftAnchor.constraint(equalTo: rowView.leftAnchor).isActive = true
                }

                if colIndex == row.count - 1 {
                    button.rightAnchor.constraint(equalTo: rowView.rightAnchor).isActive = true
                }

                button.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true

                previousButton = button
            }

            previousRow = rowView
        }

        return view
    }

    // 创建功能按钮区域
    private func createFunctionButtons() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        // 数字0按钮（点击输入0，长按切换键盘）
        let zeroButton = UIButton(type: .system)
        zeroButton.translatesAutoresizingMaskIntoConstraints = false
        zeroButton.setTitle("0", for: .normal)
        zeroButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        zeroButton.backgroundColor = .white
        zeroButton.setTitleColor(.black, for: .normal)
        zeroButton.layer.cornerRadius = 6
        zeroButton.layer.shadowColor = UIColor.black.cgColor
        zeroButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        zeroButton.layer.shadowOpacity = 0.2
        zeroButton.layer.shadowRadius = 0
        // 点击输入0
        zeroButton.addTarget(self, action: #selector(numberKeyPressed(_:)), for: .touchUpInside)
        // 添加长按手势识别器用于切换键盘
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleZeroButtonLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5 // 长按0.5秒触发
        zeroButton.addGestureRecognizer(longPressGesture)
        view.addSubview(zeroButton)

        // 删除键
        let deleteButton = createKeyButton(title: "删除", action: #selector(deleteKeyPressed))
        deleteButton.backgroundColor = UIColor(red: 0.67, green: 0.67, blue: 0.69, alpha: 1.0)
        view.addSubview(deleteButton)

        // 空格键
        let spaceButton = createKeyButton(title: "空格", action: #selector(spaceKeyPressed))
        view.addSubview(spaceButton)

        // 换行键
        let returnButton = createKeyButton(title: "换行", action: #selector(returnKeyPressed))
        returnButton.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        returnButton.setTitleColor(.white, for: .normal)
        view.addSubview(returnButton)

        NSLayoutConstraint.activate([
            zeroButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            zeroButton.topAnchor.constraint(equalTo: view.topAnchor),
            zeroButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            zeroButton.widthAnchor.constraint(equalToConstant: 60),

            deleteButton.leftAnchor.constraint(equalTo: zeroButton.rightAnchor, constant: 4),
            deleteButton.topAnchor.constraint(equalTo: view.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 80),

            spaceButton.leftAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: 4),
            spaceButton.topAnchor.constraint(equalTo: view.topAnchor),
            spaceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            returnButton.leftAnchor.constraint(equalTo: spaceButton.rightAnchor, constant: 4),
            returnButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            returnButton.topAnchor.constraint(equalTo: view.topAnchor),
            returnButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            returnButton.widthAnchor.constraint(equalToConstant: 80)
        ])

        return view
    }

    // 创建按键
    private func createKeyButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 0
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Input Logic

    @objc private func numberKeyPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }

        // 限制最多输入4位数字
        if inputBuffer.count < 4 {
            inputBuffer += number
            updateDisplay()

            // 如果已经输入4位数字，自动查找并输入汉字
            if inputBuffer.count == 4 {
                processPositionCode()
            }
        }
    }

    @objc private func deleteKeyPressed() {
        if !inputBuffer.isEmpty {
            inputBuffer.removeLast()
            updateDisplay()
        } else {
            textDocumentProxy.deleteBackward()
        }
    }

    @objc private func spaceKeyPressed() {
        textDocumentProxy.insertText(" ")
    }

    @objc private func returnKeyPressed() {
        textDocumentProxy.insertText("\n")
    }

    // 处理0按钮的长按手势
    @objc private func handleZeroButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // 长按开始时切换键盘
            if let button = gesture.view as? UIButton {
                handleInputModeList(from: button, with: UIEvent())
            }
        }
    }

    // 更新显示
    private func updateDisplay() {
        inputLabel.text = "区位码: \(inputBuffer)"

        // 实时预览候选字
        if inputBuffer.count == 4 {
            let area = Int(inputBuffer.prefix(2)) ?? 0
            let position = Int(inputBuffer.suffix(2)) ?? 0

            if let character = GB2312Data.shared.getCharacter(area: area, position: position) {
                candidateLabel.text = character
            } else {
                candidateLabel.text = "未找到"
            }
        } else {
            candidateLabel.text = ""
        }
    }

    // 处理区位码输入
    private func processPositionCode() {
        guard inputBuffer.count == 4 else { return }

        let area = Int(inputBuffer.prefix(2)) ?? 0
        let position = Int(inputBuffer.suffix(2)) ?? 0

        if let character = GB2312Data.shared.getCharacter(area: area, position: position) {
            textDocumentProxy.insertText(character)
        }

        // 清空输入缓冲区
        inputBuffer = ""
        updateDisplay()
    }

    // MARK: - Text Input Callbacks

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents
    }
}

// 将 GB2312Data 复制到键盘扩展中使用
class GB2312Data {
    static let shared = GB2312Data()
    private init() {}

    func getCharacter(area: Int, position: Int) -> String? {
        guard area >= 1 && area <= 94 && position >= 1 && position <= 94 else {
            return nil
        }

        let highByte = area + 0xA0
        let lowByte = position + 0xA0
        let gb2312Bytes: [UInt8] = [UInt8(highByte), UInt8(lowByte)]

        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))

        if let str = String(bytes: gb2312Bytes, encoding: encoding) {
            return str
        }

        return nil
    }
}

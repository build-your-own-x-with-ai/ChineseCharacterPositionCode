//
//  GB2312Data.swift
//  ChineseCharacterPositionCode
//
//  Created by i on 2025/11/29.
//

import Foundation

/// GB2312 区位码数据管理类
class GB2312Data {
    static let shared = GB2312Data()

    private init() {}

    /// 根据区位码获取汉字
    /// - Parameters:
    ///   - area: 区号 (1-94)
    ///   - position: 位号 (1-94)
    /// - Returns: 对应的汉字，如果不存在则返回 nil
    func getCharacter(area: Int, position: Int) -> String? {
        guard area >= 1 && area <= 94 && position >= 1 && position <= 94 else {
            return nil
        }

        // GB2312 的区位码转换为 GB2312 编码
        // GB2312 编码 = (区号 + 0xA0) * 256 + (位号 + 0xA0)
        let highByte = area + 0xA0
        let lowByte = position + 0xA0

        // 构建 GB2312 编码的字节序列
        let gb2312Bytes: [UInt8] = [UInt8(highByte), UInt8(lowByte)]

        // 将 GB2312 编码转换为 Unicode 字符串
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))

        if let str = String(bytes: gb2312Bytes, encoding: encoding) {
            return str
        }

        return nil
    }

    /// 获取所有 GB2312 字符的区位码信息
    /// - Returns: 字符信息数组，按区位码排序
    func getAllCharacters() -> [CharacterInfo] {
        var result: [CharacterInfo] = []

        // 遍历所有区位码
        for area in 1...94 {
            for position in 1...94 {
                if let character = getCharacter(area: area, position: position) {
                    // 过滤掉控制字符和空白字符
                    if !character.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let info = CharacterInfo(
                            character: character,
                            area: area,
                            position: position,
                            code: String(format: "%02d%02d", area, position)
                        )
                        result.append(info)
                    }
                }
            }
        }

        return result
    }

    /// 获取指定区的所有字符
    /// - Parameter area: 区号 (1-94)
    /// - Returns: 该区的字符信息数组
    func getCharactersInArea(_ area: Int) -> [CharacterInfo] {
        guard area >= 1 && area <= 94 else {
            return []
        }

        var result: [CharacterInfo] = []

        for position in 1...94 {
            if let character = getCharacter(area: area, position: position) {
                if !character.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let info = CharacterInfo(
                        character: character,
                        area: area,
                        position: position,
                        code: String(format: "%02d%02d", area, position)
                    )
                    result.append(info)
                }
            }
        }

        return result
    }
}

/// 字符信息结构
struct CharacterInfo: Identifiable, Hashable {
    let id = UUID()
    let character: String  // 汉字
    let area: Int         // 区号
    let position: Int     // 位号
    let code: String      // 区位码（4位数字字符串）

    /// 获取区位码描述
    var codeDescription: String {
        return "\(String(format: "%02d", area))区\(String(format: "%02d", position))位"
    }
}

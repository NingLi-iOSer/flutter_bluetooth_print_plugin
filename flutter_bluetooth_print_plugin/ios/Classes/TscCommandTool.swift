//
//  TscCommandTool.swift
//  flutter_bluetooth_print_plugin
//
//  Created by Ning Li on 2019/12/9.
//

struct TscCommandTool {
    
    private var items: [PrintLabelInfoModel]
    
    /// 初始化
    /// - Parameter infos: 打印标签信息数组
    init?(infos: [Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: infos, options: []),
            let list = try? JSONDecoder().decode([PrintLabelInfoModel].self, from: data)
            else {
                return nil
        }
        items = list
    }
    
    /// 创建打印标签指令
    /// - Parameter dpi: 打印机分辨率
    func createCommands(dpi: CGFloat) -> [Data] {
        let ratio = CGFloat(dpi / 200 * 8)
        var commands = [Data]()
        items.forEach { (printInfo) in
            guard let list = printInfo.itemConfigList else {
                return
            }
            let command = TscCommand()
            command.addSize(Int32(printInfo.width), Int32(printInfo.height))
            command.addGap(withM: 2, withN: 0)
            command.addReference(Int32(ratio), 0)
            command.addTear("ON")
            command.addQueryPrinterStatus(Response.ON)
            command.addDensity(10)
            command.addCls()
            list.forEach { (item) in
                switch item.itemType {
                case .QRCode: // 二维码
                    let flag: CGFloat
                    switch ratio {
                    case 8:
                        flag = 3
                    case 12:
                        flag = 4
                    default:
                        flag = 1.5
                    }
                    let cellWidth = Int32((item.width * 10 / printInfo.width) * flag)
                    command.addQRCode(Int32(item.x * ratio), Int32(item.y * ratio), "L", cellWidth, "A", 0, item.value ?? "")
                case .text: // 文本
                    command.addTextwithX(Int32(item.x * ratio), withY: Int32(item.y * ratio), withFont: "TSS24.BF2", withRotation: 0, withXscal: Int32(item.fontSize ?? 1), withYscal: Int32(item.fontSize ?? 1), withText: item.value ?? "")
                }
            }

            command.addPrint(1, 1)
            if let data = command.getCommand() {
                commands.append(data)
            }
        }
        return commands
    }
}

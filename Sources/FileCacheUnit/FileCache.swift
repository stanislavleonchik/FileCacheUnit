import Foundation

public protocol JsonCompatible {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

public protocol CsvCompatible {
    var csv: String { get }
    static func parse(csv: Substring) -> Self?
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public final class FileCache<T: Identifiable & JsonCompatible & CsvCompatible> {
    public var todoitems: [T.ID: T] = [:]
    public var revision: Int = 0
    public var items: [T] {
        return Array(todoitems.values)
    }
    
    public init() {}

    public func addItem(_ item: T) {
        todoitems[item.id] = item
    }
    
    public func removeItem(_ id: T.ID) {
        todoitems[id] = nil
    }
    
    public func updateItem(_ id: T.ID, _ item: T) {
        todoitems[id] = item
    }
    
    public subscript(id: T.ID) -> T? {
        get {
            return todoitems[id]
        }
        set {
            todoitems[id] = newValue
        }
    }
    
    public func save(to fileName: String) throws {
        let fileExtension = (fileName as NSString).pathExtension.lowercased()
        guard let fileURL = getCacheDirectory()?.appendingPathComponent(fileName) else { return }

        switch fileExtension {
        case "json":
            let json = todoitems.values.map { $0.json }
            var jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            jsonData.append(contentsOf: try JSONEncoder().encode(["revision": revision]))
            try jsonData.write(to: fileURL)
            
        case "csv":
            var csvString = "id,text,importance,deadline,isDone,dateCreated,dateChanged\n"
            for item in items {
                csvString.append(item.csv)
            }
            csvString.append("revision,\(revision)\n")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
        default:
            throw NSError(domain: "FileCacheError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported file format"])
        }
    }
    
    public func load(from fileName: String) throws {
        let fileExtension = (fileName as NSString).pathExtension.lowercased()
        guard let fileURL = getCacheDirectory()?.appendingPathComponent(fileName) else { return }

        switch fileExtension {
        case "json":
            guard let jsonArray = try JSONSerialization.jsonObject(with: try Data(contentsOf: fileURL), options: []) as? [[String: Any]] else { return }
            for json in jsonArray {
                if let revisionValue = json["revision"] as? Int {
                    revision = revisionValue
                } else {
                    let temp = T.parse(json: json)
                    if let id = temp?.id {
                        todoitems[id] = temp
                    }
                }
            }
            
        case "csv":
            let csvString = try String(contentsOf: fileURL)
            let rows = csvString.split(separator: "\n").dropFirst()

            var loadedItems: [T.ID: T] = [:]
            for row in rows {
                if row.hasPrefix("revision") {
                    let revisionString = row.split(separator: ",").last ?? "0"
                    revision = Int(revisionString) ?? 0
                } else {
                    guard let temp = T.parse(csv: row) else { continue }
                    loadedItems[temp.id] = temp
                }
            }

            for (id, item) in loadedItems {
                todoitems[id] = item
            }
        
        default:
            throw NSError(domain: "FileCacheError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported file format"])
        }
    }
    
    private func getCacheDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[safe: 0]
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

import Foundation

public struct Todoitem: Identifiable {
    public enum Importance: String {
        case unimportant = "unimportant"
        case ordinary = "ordinary"
        case important = "important"
    }
    
    public let id: String
    public var text: String
    public var importance: Importance
    public var deadline: Date?
    public var isDone: Bool
    public let dateCreated: Date
    public let dateChanged: Date?
    public var color: String?
    public var category: TodoCategory
    
    public init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .ordinary,
         deadline: Date? = nil,
         isDone: Bool,
         dateCreated: Date = Date(),
         dateChanged: Date? = nil,
         category: TodoCategory = .other) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.dateCreated = dateCreated
        self.dateChanged = dateChanged
        self.category = category
    }
}

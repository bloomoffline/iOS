public enum ChatStatus: String, Codable, Hashable, CaseIterable, CustomStringConvertible {
    case online = "Online"
    case busy = "Busy"
    case emergency = "Emergency"
//    case offline = "Offline"
    
    public var description: String { rawValue }
}

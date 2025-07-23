struct Environment {

    static func isProduction() -> Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }

}

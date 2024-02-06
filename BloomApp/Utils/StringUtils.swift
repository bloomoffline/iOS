//
//  StringUtils.swift
//  BloomApp
//
//  
//

extension String {
    func pluralized(with n: Int) -> String {
        n == 1 ? self : "\(self)s"
    }
}

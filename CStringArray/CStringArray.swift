//
//  CStringArray.swift
//  CStringArray
//
//  Created by hnw on 2016/06/25.
//  Copyright © 2016年 hnw. All rights reserved.
//

import Foundation

// Is this really the best way to extend the lifetime of C-style strings? The lifetime
// of those passed to the String.withCString closure are only guaranteed valid during
// that call. Tried cheating this by returning the same C string from the closure but it
// gets dealloc'd almost immediately after the closure returns. This isn't terrible when
// dealing with a small number of constant C strings since you can nest closures. But
// this breaks down when it's dynamic, e.g. creating the char** argv array for an exec
// call.
class CString : CustomStringConvertible {
    private let _len: Int
    let buffer: UnsafeMutablePointer<CChar>
    
    init(_ string: String) {
        (_len, buffer) = string.withCString {
            let len = Int(strlen($0) + 1)
            let dst = strcpy(UnsafeMutablePointer<CChar>.alloc(len), $0)
            return (len, dst)
        }
    }
    
    deinit {
        buffer.dealloc(_len)
    }

    var description: String {
        return String.fromCString(buffer)!
    }
}

// An array of C-style strings (e.g. char**) for easier interop.
public class CStringArray : CustomStringConvertible {
    // Have to keep the owning CString's alive so that the pointers
    // in our buffer aren't dealloc'd out from under us.
    private let _strings: [CString?]
    public var pointers: [UnsafeMutablePointer<CChar>]

    public init(_ strings: [String?]) {
        _strings = strings.map { $0.map { CString($0) } }
        pointers = _strings.map { $0 != nil ? $0!.buffer : nil }
    }

    public var description: String {
        let desc_array = _strings.map { $0 != nil ? "\"\($0!)\"" : "NULL" }
        let desc = desc_array.joinWithSeparator(", ")
        return "CStringArray([\(desc)])"
    }
}
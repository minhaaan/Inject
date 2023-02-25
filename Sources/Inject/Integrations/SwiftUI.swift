import Foundation
import SwiftUI

#if DEBUG
@available(iOS 13.0, *)
public extension SwiftUI.View {
    func enableInjection() -> some SwiftUI.View {
        _ = InjectionIII.load
        
        // Use AnyView in case the underlying view structure changes during injection.
        // This is only in effect in debug builds.
        return AnyView(self)
    }

    func onInjection(callback: @escaping (Self) -> Void) -> some SwiftUI.View {
        onReceive(InjectionIII.observer.objectWillChange, perform: {
            callback(self)
        })
        .enableInjection()
    }
}

@available(iOS 13.0, *)
@propertyWrapper
public struct ObserveInjection: DynamicProperty {
    @ObservedObject private var iO = InjectionIII.observer
    public init() {}
    public private(set) var wrappedValue: InjectionIII.Type = InjectionIII.self
}

#else
@available(iOS 13.0, *)
public extension SwiftUI.View {
    @inlinable @inline(__always)
    func enableInjection() -> Self { self }

    @inlinable @inline(__always)
    func onInjection(callback: @escaping (Self) -> Void) -> Self {
        self
    }
}

@available(iOS 13.0, *)
@propertyWrapper
public struct ObserveInjection {
    public init() {}
    public private(set) var wrappedValue: InjectionIII.Type = InjectionIII.self
}
#endif

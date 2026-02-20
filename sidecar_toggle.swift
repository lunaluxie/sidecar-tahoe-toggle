import Foundation

guard let _ = dlopen("/System/Library/PrivateFrameworks/SidecarCore.framework/SidecarCore", RTLD_LAZY) else { exit(1) }
guard let managerClass = NSClassFromString("SidecarDisplayManager") as? NSObject.Type,
      let manager = managerClass.perform(Selector(("sharedManager")))?.takeUnretainedValue() else { exit(1) }
guard let devices = manager.perform(Selector(("devices")))?.takeUnretainedValue() as? [AnyObject] else { exit(1) }
guard let ipad = devices.first(where: {
    ($0.perform(Selector(("name")))?.takeUnretainedValue() as? String) == "IPAD_NAME_HERE"
}) else { exit(1) }

let connectedDevices = manager.perform(Selector(("connectedDevices")))?.takeUnretainedValue() as? [AnyObject] ?? []
let isConnected = connectedDevices.contains(where: {
    ($0.perform(Selector(("name")))?.takeUnretainedValue() as? String) == "IPAD_NAME_HERE"
})

let sema = DispatchSemaphore(value: 0)
let closure: @convention(block) (AnyObject?, AnyObject?) -> Void = { _, _ in sema.signal() }
let blockObject = unsafeBitCast(closure, to: AnyObject.self)

if isConnected {
    manager.perform(Selector(("disconnectFromDevice:completion:")), with: ipad, with: blockObject)
} else {
    manager.perform(Selector(("connectToDevice:completion:")), with: ipad, with: blockObject)
}
sema.wait()

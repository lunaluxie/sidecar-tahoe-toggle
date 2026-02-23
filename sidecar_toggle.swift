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

var closure: AnyObject?
// init closure with signature dependeing on mac version to avoid segfaulting on tahoe.
if #available(macOS 26, *) {
    // update closure signature for macOS 26 (tested on 26.2)
    closure = ({ sema.signal() } as @convention(block) () -> Void) as AnyObject
} else {
    closure = ({ _, _ in sema.signal() } as @convention(block) (AnyObject?, AnyObject?) -> Void) as AnyObject
}
// don't need unsafeBitCast as we have already casted closure to common AnyObject.

if isConnected {
    let _ = manager.perform(Selector(("disconnectFromDevice:completion:")), with: ipad, with: closure)

} else {
    let _ = manager.perform(Selector(("connectToDevice:completion:")), with: ipad, with:closure)

}
sema.wait()
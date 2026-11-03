require "c/stdlib"

# Prefer explicit exit over returning the status, so we are free to resume the
# main thread's fiber on any thread, without occurring a weird behavior where
# another thread returns from main when the caller might expect the main thread
# to be the one returning.

# On iOS the process entry symbol (`main`) belongs to the UIKit driver, which
# calls the Crystal entry point on a background thread so the Crystal scheduler
# doesn't block the main (UI) thread.
{% if flag?(:ios) %}
fun crystal_main_entry(argc : Int32, argv : UInt8**) : Int32
  status = Crystal.main(argc, argv)
  LibC.exit(status)
end
{% else %}
fun main(argc : Int32, argv : UInt8**) : Int32
  status = Crystal.main(argc, argv)
  LibC.exit(status)
end
{% end %}

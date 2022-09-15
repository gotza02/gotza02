cmd package compile -f -m everything com.linecorp.lineman.driver
cmd package compile -f -m everything ch.gridvision.ppam.androidautomagic
cmd package compile --compile-layouts -f ch.gridvision.ppam.androidautomagic
cmd package compile --compile-layouts -f com.linecorp.lineman.driver
cmd package bg-dexopt-job

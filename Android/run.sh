#!/bin/bash

echo "Installing performance tweaks..."

properties=(

"debug.hwui.renderer.texture surfacetexture"

"debug.hwui.thread\_scheduler.type performance"

"debug.hwui.layer\_cache\_key\_hashing true"

"debug.hwui.renderengine.backend skiagpu"

"debug.hwui.use\_empty\_frame 1"

"debug.sf.vblank\_presentation 1"

"debug.cpu\_core\_ctl\_active 1"

"debug.cpu\_core\_ctl\_max\_cores 8"

"debug.cpu\_efficiency 1.0"

"debug.cpu\_core\_ctrl\_hispeed\_load 80"

"debug.powersaver.ignore\_adaptive\_battery true"

"debug.sf.latch\_unlocked 1"

"debug.cpu\_core\_ctl\_max\_cores 8"

)

apply\_properties() {

local success\_count=0 failure\_count=0

for prop in "${properties\[@\]}"; do

setprop $prop >/dev/null 2>&1 && success\_count=$((success\_count + 1)) || failure\_count=$((failure\_count + 1))

done

echo "• Properties applied: $success\_count"

echo "• Properties failed: $failure\_count"

}

global\_settings=(

"ram\_expand\_size 6144000"

"hardwareAccelerated true"

"storage\_preload 1"

)

apply\_settings() {

local scope=$1 success\_count=0 failure\_count=0

for setting in "${@:2}"; do

settings put $scope $setting >/dev/null 2>&1 && success\_count=$((success\_count + 1)) || failure\_count=$((failure\_count + 1))

done

echo "• $scope settings applied: $success\_count" 

echo "• $scope settings failed: $failure\_count"

}

secure\_settings=(

"multi\_press\_timeout 150"

"long\_press\_timeout 150"

)

cmd\_settings=(

"power set-fixed-performance-mode-enabled true"

"power set-adaptive-power-saver-enabled false"

)

apply\_cmd\_settings() {

local success\_count=0 failure\_count=0

for setting in "${cmd\_settings\[@\]}"; do

cmd $setting >/dev/null 2>&1 && success\_count=$((success\_count + 1)) || failure\_count=$((failure\_count + 1)) 

done

echo "• CMD settings applied: $success\_count"

echo "• CMD settings failed: $failure\_count" 

}

main() {

apply\_properties

apply\_settings global "${global\_settings\[@\]}"

apply\_settings secure "${secure\_settings\[@\]}"  

apply\_cmd\_settings

cmd activity kill-all >/dev/null 2>&1

echo "🚀 Performance tweaks successfully installed. Enjoy!"

}

main

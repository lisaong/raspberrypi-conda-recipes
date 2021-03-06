#!/usr/bin/env bash

rm -rf build
mkdir -p build


find ../conda-recipes-scitools -name "meta.yaml" -exec sh -c 'cp -rf "${0%/*}" build/' {} \;
find ../staged-recipes/recipes -name "meta.yaml" -exec sh -c 'cp -rf "${0%/*}" build/' {} \;
find recipes -maxdepth 2 -name "meta.yaml" -exec sh -c 'cp -rf "${0%/*}" build/' {} \;


# Because it needs Jupyter, which hasn't been packaged yet.
rm -rf build/xonsh


#obvci_conda_build_dir.py build raspberrypi --build-condition "python >=2.7,<3|>=3.4" "numpy >=1.8,<1.9"
conda-build-all build --matrix-conditions "python >=2.7,<3|>=3.4" "numpy >=1.8,<1.9" --inspect-channels raspberrypi --upload-channels raspberrypi


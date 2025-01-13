# Dockerfiles

{:toc}

## Changelog of Deformable-DETR

### 1.0.0 @ 01/13/2025

#### :mega: New

1. Finish the script of building `Deformable-DETR` on `Python:3.12-slim` and `CUDA:12.4`.

#### :wrench: Fix

1. Fix: Correct a typo in the installation script.
2. Fix: Split the CUDA compiling in another script because it is not usable during the `docker build`.
3. Fix: Add the missing link in the readme file.

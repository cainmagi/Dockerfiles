# Dockerfiles

{:toc}

## TeXLive with Code

### 1.0.1 @ 04/25/2025

#### :mega: New

1. Support the SSL mode (experimental feature, which may have bugs if not deployed on localhost).

#### :wrench: Fix

1. Fix: Correct the `user-mapping.sh` script and use the target user name to reconfigure the code-server.
2. Fix: Add a User ID check. If a user with an ID `1000` exists, will delete the user. This update secures that the user ID mapping to work correctly.
3. Fix: Correct a bug of the user detection.
4. Fix: Correct the path of the SSL configuration file.

#### :floppy_disk: Change

1. Remove the extensions that are not supported by open-vsx.
2. Adjust the configuration override order.

### 1.0.0 @ 04/24/2025

#### :mega: New

1. Create this project.
2. Finish the script of building `TeXLive` with `Code Server`.

#### :wrench: Fix

1. Fix: Correct the `user-mapping.sh` script used for rebasing the file ownership.

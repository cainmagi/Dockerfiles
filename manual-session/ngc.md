# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view extra manuals about xUbuntu, click [here](../manual-xubuntu).

To view the **contents** of these manuals, click [here](../manual-session).

## Work with NVIDIA GPU Cloud (NGC)

> Updated on 4/20/2022

This guide will help you register your personal NGC API Key on our DGX machine. Then you can use `docker pull` to fetch the images from NVIDIA or our [private containers][docs-list] directly.

* **Step 1**: Go to the following address and login with your personal NGC account. This account should be authorized to you by our email before.

    ```addr
    https://ngc.nvidia.com/signin
    ```

    |   Step 1 (In Browser)  |
    | :----------------------------: |
    | ![step-1](./display/ngc/step-1.jpg) |

    Click the <kbd>Continue</kbd> button for the NVIDIA account.

* **Step 2**: Login with your username and password:

    |   Step 2 (In Browser)  |
    | :----------------------------: |
    | ![step-2](./display/backend/step-2.png) |

[docs-list]:../dockerlist

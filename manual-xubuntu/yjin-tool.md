# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view extra manuals about xUbuntu, click [here](../manual-xubuntu).

## `yjin-tool`

> Updated on 4/19/2022

This script is mainly designed for helping users make configurations and file modifications quickly. To learn the usage of the script, users could type

```bash
yjin-tool --help
```

The newest script can be found here:

[https://gist.github.com/cainmagi/0b3159c956422e2f55492ad3bd6b555f :link:](https://gist.github.com/cainmagi/0b3159c956422e2f55492ad3bd6b555f)

Here we explain some mostly used usages:

### `--df`

Running the script without any arguments will be equivalent to run the following command:

```bash
yjin-tool --df
```

It will return the detailed usage of the hard disk.

### `--du`

This method is used for checking the disk consumption of folders or files. To summarize the sizes of all sub-folders and files in the current directory, just type:

```bash
sudo yjin-tool --du *
```

It can be used like this:

```bash
sudo yjin-tool --du folder1 folder2
```

### `--mod`

Change the owner and group of any files, and add `+rwx` authority to them.

```bash
sudo yjin-tool --mod folder1 file1 user=xubuntu
```

This command can help users to change the ownership of a file owned by `root` quickly.

The last argument `user=<...>` is always required to be configured. It means the new owner will be `xubuntu`.

### `--rmvnc`

```bash
yjin-tool --rmvnc
```

It is equivalent to

```bash
tigervncserver -kill :1
```

### `--ln`

This command will create soft links in a specific folder, the usage is like this:

```bash
yjin-tool --ln folder1 folder2 file1 file2 ... target=.
```

For each path, if it is a folder (like `folder1` or `folder2`), the command will iterate each file inside the folder, and create the symbolic links of these iterated files. However, if the given path is a file, the symbol link will be used created from the given file.

This command will not walk into the sub-folders recursively.

The last argument `target=.` means that the symbolic links will be created in the current folder.

### `--gitconfig`

This command will be used for creating environmental variable related to git configurations. The usage is like this:

```bash
yjin-tool --gitconfig user=<your-git-id> token=<your-git-token>.
```

The first argument `user=<...>` should not be `xubuntu`. Instead, it should be your Github ID. The second argument should be your Github OAuth Token.

After making this configurations, you can clone a private repository like this:

```bash
git clone https://${GITTOKEN}@github.com/<your-git-id>/<your-git-repo>.git <folder-name>
```

The clone can be done instantly. It will not ask you the token now.

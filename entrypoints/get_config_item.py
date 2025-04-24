# -*- coding: UTF-8 -*-
"""
Get the configuration item
==========================

Author
------
Yuchen Jin (cainmagi)
cainmagi@gmail.com

License
-------
MIT License

Description
-----------
Get an item of the configuration and print it as a string. This script is used by
Bash.
"""

import os

from typing import Union

import yaml


PathLike = Union[str, os.PathLike]
__version__ = "1.0.0"


def sanitize_path(path: PathLike, ext: str = "yaml") -> str:
    """Sanitize a path.

    Ensure that the given path refers an existing file.

    Arguments
    ---------
    path: `str | os.PathLike`
        The path to be sanitized.

    ext: `str`
        The file name extension to be used during the sanitization.

        This value can either start with a `.` symbol or not.

    Returns
    -------
    #1: `str`
        A sanitized path. If the path is not corresponding to an existing file, will
        return an empty string `""`.
    """
    path = str(os.path.expandvars(os.path.expanduser(str(path).strip())))
    ext = str(ext).strip() if ext else ""
    if not path:
        return ""
    if os.path.isfile(path):
        return path
    _base, _ext = os.path.splitext(path)
    _ext = _ext.strip().casefold()
    if _ext == ext:
        return ""
    if not ext:
        if os.path.isfile(_base):
            return _base
        return ""
    _path = "{0}.{1}".format(_base, ext)
    if os.path.isfile(_path):
        return _path
    _path = _base
    if os.path.isfile(_path):
        return _path
    _path = "{0}.{1}".format(path, ext)
    if os.path.isfile(_path):
        return _path
    return ""


def get_code_config(path_config: PathLike, key: str) -> str:
    """Get the configuration item.

    Arguments
    ---------
    path_config: `str | os.PathLike`
        The path to the file where the VSCode configuration is.

    key: `str`
        The name of the configuration item.

    Returns
    -------
    #1: `str`
        The configuration item converted to a string.
    """
    path_config = sanitize_path(path_config)
    if not path_config:
        return ""
    with open(path_config, "r", encoding="utf-8") as fobj:
        data = dict(yaml.load(fobj, Loader=yaml.SafeLoader))
    if key in data:
        val = data[key]
        if not val:
            return ""
        return str(data[key])
    return ""


if __name__ == "__main__":
    import argparse

    def parse_args(parser: argparse.ArgumentParser) -> argparse.Namespace:
        """Argument parsing."""
        parser.add_argument(
            "-v",
            "--version",
            version=__version__,
            action="version",
            help="If specified, show the current version.",
        )
        parser.add_argument(
            "-p",
            "--path-config",
            default="",
            metavar="str",
            help=(
                "The path to the configuration file to be read. It can contain "
                "the user folder or an environment variable."
            ),
        )
        parser.add_argument(
            "-k",
            "--key",
            default="",
            metavar="str",
            help=("The key of the configuration item to be read."),
        )
        return parser.parse_args()

    # Set parser and parse args.
    vparser = argparse.ArgumentParser(
        description="Launch dashboard with properties.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    vargs = parse_args(vparser)

    val = get_code_config(vargs.path_config, vargs.key)
    if val:
        print(val)
    else:
        print("")

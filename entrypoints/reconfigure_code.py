# -*- coding: UTF-8 -*-
"""
Reconfigure VSCode
==================

Author
------
Yuchen Jin (cainmagi)
cainmagi@gmail.com

License
-------
MIT License

Description
-----------
This script reads and updates the configuration file of VSCode.
"""

import os
import subprocess
import collections.abc

from typing import Union, Optional, Any

try:
    from typing import Mapping
except ImportError:
    from collections.abc import Mapping

import yaml


PathLike = Union[str, os.PathLike]
__version__ = "1.0.0"


def get_user_configuration(
    vscode_password: Optional[str] = None,
    github_token: Optional[str] = None,
    *,
    user_interactive: bool = True
):
    """Get the user configurations. If they cannot be found in the script argument,
    or the environmental variable, ask for these values.

    Arguments
    ---------
    vscode_password: `str`
        The password when launching the VSCode.

    github_token: `str`
        The token used for accessing the GitHub.

    user_interactive: `bool`
        Will enable the user interactive features if allowed. If this flag is disabled,
        will make the not found configuration item an empty string.

    Returns
    -------
    #1: `Dict[str, Any]`
        A dictionary containing all parsed configurations.
    """
    if isinstance(vscode_password, str) and (not vscode_password):
        vscode_password = None
    if isinstance(github_token, str) and (not github_token):
        github_token = None
    pw_hashed: bool = False
    if vscode_password is None:
        vscode_password = os.environ.get("VSCODE_PASSWORD", None)
        if vscode_password:
            pw_hashed = True
        if vscode_password is None:
            vscode_password = os.environ.get("PASSWORD", None)
        if vscode_password is None:
            vscode_password = ""
        vscode_password = str(vscode_password)
        if user_interactive and (not vscode_password):
            pw_hashed = False
            vscode_password = str(input("Provide the password of the VSCode: "))
    else:
        pw_hashed = True
    if github_token is None:
        github_token = os.environ.get("GITHUB_TOKEN", None)
        if github_token is None:
            github_token = ""
        github_token = str(github_token)
        if user_interactive and (not github_token):
            github_token = str(input("Provide the GitHub Token: "))
    vscode_password = vscode_password.strip()
    github_token = github_token.strip()
    res = {
        "github-auth": github_token,
    }
    res.update(
        {"hashed-password": vscode_password}
        if pw_hashed
        else {"password": vscode_password}
    )
    return res


def get_locale() -> str:
    """Get the Locale from the system variable. If not available, will use `en`."""
    cur_local = os.environ.get("LANG", None)
    if (not isinstance(cur_local, str)) or (not cur_local):
        return "en"
    cur_local = cur_local.casefold().split(".", maxsplit=1)[0]
    supported = (
        "en",
        "zh-cn",
        "zh-tw",
        "fr",
        "de",
        "it",
        "es",
        "ja",
        "ko",
        "ru",
        "pt-br",
        "tr",
        "pl",
        "cs",
        "hu",
    )
    for lang in supported:
        if cur_local.startswith(lang):
            return lang
    return "en"


def get_textlive_version() -> str:
    """Get the TeXLive version by one command."""
    try:
        val = subprocess.check_output(
            "latex --version", shell=True, text=True, encoding="utf-8"
        )
    except subprocess.CalledProcessError:
        val = "TeXLive (Unknown)"
    else:
        val = val.splitlines()[0].strip()
    return val


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


def update_code_configs(path_config: PathLike, new_configs: Mapping[str, Any]) -> None:
    """Update the VSCode configurations.

    Will do nothing if the given path is invalid.

    Arguments
    ---------
    path_config: `str | os.PathLike`
        The path to the file where the VSCode configuration is.

    new_configs: `Mapping[str, Any]`
        The new configurations that would be used for updating `path_config`.
    """
    path_config = sanitize_path(path_config)
    if not path_config:
        return
    with open(path_config, "r", encoding="utf-8") as fobj:
        data = dict(yaml.load(fobj, Loader=yaml.SafeLoader))
    for key, val in new_configs.items():
        if val is None:
            continue
        if isinstance(val, str) and (not val):
            continue
        if isinstance(val, collections.abc.Sequence) and (not val):
            continue
        if isinstance(val, collections.abc.Mapping) and (not val):
            continue
        data[key] = val
    if "hashed-password" in data and (not data["hashed-password"]):
        del data["hashed-password"]
    with open(path_config, "w", encoding="utf-8") as fobj:
        yaml.dump(
            data,
            fobj,
            Dumper=yaml.SafeDumper,
            indent=2,
            allow_unicode=True,
            encoding="utf-8",
        )


if __name__ == "__main__":
    import argparse

    def str2bool(value: str) -> bool:
        """str to bool conversion for argparse."""
        if value.lower() in ("yes", "true", "t", "y", "1"):
            return True
        elif value.lower() in ("no", "false", "f", "n", "0"):
            return False
        else:
            raise argparse.ArgumentTypeError("Unsupported value encountered.")

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
                "The path to the configuration file to be updated. It can contain "
                "the user folder or an environment variable."
            ),
        )
        parser.add_argument(
            "-vp",
            "--vscode-password",
            default="",
            metavar="str",
            help=(
                "The hashed password. This password is generated by argon2 and will"
                "be used for configuring the launch of the vscode server."
            ),
        )
        parser.add_argument(
            "-gt",
            "--github-token",
            default="",
            metavar="str",
            help=(
                "The GitHub token used for accessing the private GitHub repositories."
            ),
        )
        parser.add_argument(
            "-ni",
            "--no-interactive",
            type=str2bool,
            nargs="?",
            const=True,
            default=False,
            metavar="bool",
            help="If set this flag, will skip the interactive features.",
        )
        return parser.parse_args()

    # Set parser and parse args.
    vparser = argparse.ArgumentParser(
        description="Launch dashboard with properties.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    vargs = parse_args(vparser)

    configs = get_user_configuration(
        vscode_password=vargs.vscode_password,
        github_token=vargs.github_token,
        user_interactive=(not vargs.no_interactive),
    )
    if vargs.no_interactive:
        configs["locale"] = get_locale()
        configs["welcome-text"] = get_textlive_version()
    update_code_configs(vargs.path_config, configs)

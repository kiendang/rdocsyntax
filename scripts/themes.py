#!/usr/bin/env python3

from collections import defaultdict
from pathlib import Path


BASE_DIR = Path(__file__).parent.parent
THEMES_DIR = BASE_DIR / 'ace' / 'lib' / 'ace' / 'theme'


def get_themes(path):
    files_by_ext = group_by(
        path.iterdir(),
        key=lambda f: f.suffix.lower(),
        value=lambda f: f.stem.lower(),
    )
    return set(files_by_ext['.js']).union(files_by_ext['.css'])


def group_by(iterable, key=None, value=None):
    key, value = (default_arg(arg, identity) for arg in (key, value))
    result = defaultdict(list)

    for x in iterable:
        result[key(x)].append(value(x))

    return result


def default_arg(arg, default):
    return arg if arg is not None else default


def identity(x):
    return x


def main():
    themes = get_themes(THEMES_DIR)
    print('\n'.join(sorted(themes)))


if __name__ == '__main__':
    main()

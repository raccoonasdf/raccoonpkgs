from setuptools import setup

setup(
    name='racmenu',
    version='1',
    python_requires='>=3.7',
    py_modules=['racmenu'],
    entry_points='''
        [console_scripts]
        racmenu=racmenu:main
    ''',
)
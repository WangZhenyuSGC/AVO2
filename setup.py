from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext as _build_ext
from Cython.Build import cythonize


class BuildAvo2Ext(_build_ext):
    """Builds AVO2 before our module."""

    def run(self):
        # Build AVO2
        import os
        import os.path
        import subprocess

        build_dir = os.path.abspath('build/AVO2')
        if not os.path.exists(build_dir):
            os.makedirs(build_dir)
            subprocess.check_call(['cmake', '../..', '-DCMAKE_CXX_FLAGS=-fPIC -fopenmp'],
                                  cwd=build_dir)
        subprocess.check_call(['cmake', '--build', '.'], cwd=build_dir)

        _build_ext.run(self)


extensions = [
    Extension('avo2', ['src/*.pyx'],
              include_dirs=['src'],
              libraries=['AVO'],
              library_dirs=['build/AVO2/src'],
              extra_compile_args=['-fPIC', '-fopenmp'],
              extra_link_args=['-fopenmp']),
]

setup(
    name="pyavo2",
    ext_modules=cythonize(extensions),
    cmdclass={'build_ext': BuildAvo2Ext},
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Intended Audience :: Education',
        'Intended Audience :: Information Technology',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Cython',
        'Topic :: Games/Entertainment :: Simulation',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
)

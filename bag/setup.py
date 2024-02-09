"""
 py2app/py2exe build script voor NLX-BAG (NLExtract voor BAG) met GUI.

 Will automatically ensure that all build prerequisites are available
 via ez_setup (Nodig?)

 Usage (Mac OS X):
     python setup.py py2app

 Usage (Windows):
     python setup.py py2exe
 """

# Zie voorbeeld crossplatform:
# https://pythonhosted.org/py2app/examples.html#cross-platform
# Nodig??
# import ez_setup
# ez_setup.use_setuptools()

import sys
from setuptools import setup, find_packages

APP = ['src/bagextractgui.py']
DATA_FILES = ['extract.conf', 'db', 'test']
NAME = 'nlxbag'
BUNDLE = 'nl.nlextract'
COPYRIGHT = 'www.nlextract.nl 2015+'
LANGUAGE = 'Dutch'

# Parse the VERSION from the versie.py source file.
VERSION = ''
with open('src/versie.py', 'r') as f:
    for line in f:
        if line.find("__version__") >= 0:
            VERSION = line.split("=")[1].strip()
            VERSION = VERSION.strip('"')
            VERSION = VERSION.strip("'")
            continue

# Each platform has extra options
if sys.platform == 'darwin':
    # Mac OSX
    extra_options = dict(
        app=APP,
        options={
            'py2app': {
                # Cross-platform applications generally expect sys.argv to
                # be used for opening files.
                'argv_emulation': True,
                'site_packages': False,
                # 'arch': 'i386',
                # 'iconfile': 'lan.icns', #if you want to add some ico
                'plist': {
                    'CFBundleName': NAME,
                    'CFBundleShortVersionString': VERSION,  # must be in X.X.X format
                    'CFBundleVersion': VERSION,
                    'CFBundleIdentifier': BUNDLE,  # optional
                    'NSHumanReadableCopyright': COPYRIGHT,  # optional
                    'CFBundleDevelopmentRegion': LANGUAGE,  # optional - English is default
                }
            }
        },
        setup_requires=['py2app'],
    )
elif sys.platform == 'win32':
    # Windows32
    extra_options = dict(
        setup_requires=['py2exe'],
        app=APP,
    )
else:
    # Ander: meestal Linux, doe PyPi setup
    with open('VERSION.txt', 'w') as f:
        f.write(VERSION)

    # Get long description text from README.md.
    with open('README.md', 'r') as f:
        readme = f.read()

    # with open('CREDITS.txt', 'r') as f:
    #     credits = f.read()
    #
    # with open('CHANGES.txt', 'r') as f:
    #     changes = f.read()

    requirements = [
        'psycopg2',
        'lxml',
        'GDAL'
    ]

    if sys.version_info < (2, 7):
        requirements.append('argparse')

    extra_options = dict(
        # Normally unix-like platforms will use "setup.py install"
        # and install the main script as such
        scripts=[APP, 'bin/bag-extract.sh'],
        description="ETL for Dutch National Addresses and Buildings (BAG) Open Data",
        license='GNU GPL v3',
        keywords='etl xsl gdal gis vector feature data bag',
        author='NLExtract Devs',
        author_email='justb4@gmail.com',
        maintainer='Just van den Broecke',
        maintainer_email='justb4@gmail.com',
        url='http://github.com/nlextract/NLExtract/bag',
        # long_description=readme + "\n" + changes + "\n" + credits,
        long_description=readme,
        packages=find_packages(exclude=['test', 'build', 'dist', 'doc', 'style']),
        namespace_packages=['src'],
        include_package_data=True,
        package_data={'': ['*.conf', '*.sql', '*.xml', '*.gml', '*.csv', '*.zip']},
        install_requires=requirements,
        tests_require=['nose'],
        test_suite='nose.collector',
        classifiers=[
            'Development Status :: 4 - Beta',
            'Environment :: Console',
            'Intended Audience :: Developers',
            'Intended Audience :: Science/Research',
            'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
            'Operating System :: OS Independent',
            'Programming Language :: Python :: 2',
            'Topic :: Scientific/Engineering :: GIS',
        ]
    )

# Final platform-dependent setup
setup(
    name=NAME,
    version=VERSION,
    data_files=DATA_FILES,
    **extra_options
)

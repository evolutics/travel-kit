import setuptools

setuptools.setup(
    entry_points={"console_scripts": ["travel-kit=travelkit.main:main"]},
    name="travelkit",
    package_data={"travelkit": ["cleaners.json"]},
    packages=setuptools.find_packages(),
)

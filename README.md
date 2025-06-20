
Here's how this is supposed to work

```
mkdir build
cd build
cmake ../
make -j`nproc`
```

For Mac users installed flex w "brew":

```
mkdir build
cd build
cmake ../ -D FL_LIBRARY=/opt/homebrew/opt/flex/lib/libfl.a -D FL_INCLUDE_DIR=/opt/homebrew/opt/flex/include -D BISON_EXECUTABLE=/opt/homebrew/opt/bison/bin/bison
make -j`nproc`
```

Once the code compiles, you can use the ``ctest`` command to run the
test suite. Peruse ``ctest --help`` output for more info

Cheatsheet:

```shell
ctest -j`nproc`
ctest --rerun-failed
ctest --output-on-failure
ctest -V
ctest -R plus.*  # (regex)
```

95% tests passed, 4 tests failed out of 84

It's able to parse a file with:
```shell
 ./kirazc -f [filename]
 ````



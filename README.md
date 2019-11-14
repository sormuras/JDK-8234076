# JDK-8234076
JBS link: https://bugs.openjdk.java.net/browse/JDK-8234076

CI build: https://github.com/sormuras/JDK-8234076/runs/303494999

## No `=` between `--module` and `NAME[/ENTRY-POINT]`

`java --module-path=mods --module com.greetings/com.greetings.Main --help`

[Step 4, Line 76](https://github.com/sormuras/JDK-8234076/commit/05b3eb103b0d97648ea6b9d7619bc3d656de866e/checks?check_suite_id=311492401#step:4:76)

```
Windows original main args:
wwwd_args[0] = java
wwwd_args[1] = --module-path=mods
wwwd_args[2] = --module
wwwd_args[3] = com.greetings/com.greetings.Main
wwwd_args[4] = --help
----_JAVA_LAUNCHER_DEBUG----
Launcher state:
	First application arg index: 4
	debug:on
	javargs:off
	program name:java
	launcher name:openjdk
	javaw:off
	fullversion:11.0.5+10-LTS
Java args:
Command line args:
argv[0] = java
argv[1] = --module-path=mods
argv[2] = --module
argv[3] = com.greetings/com.greetings.Main
argv[4] = --help

...

Module is 'com.greetings/com.greetings.Main'
App's argc is 1
    argv[ 0] = '--help'
4393 micro seconds to load main class
----_JAVA_LAUNCHER_DEBUG----
AppArgIndex: 4 points to --help
F--help
Greetings! [--help]
```

First application arg index: `4` with `argv[4] = --help`. ✔

## With `=` between `--module` and `NAME[/ENTRY-POINT]`

`java --module-path=mods --module=com.greetings/com.greetings.Main --help`

[Step 5, Line 76](https://github.com/sormuras/JDK-8234076/commit/05b3eb103b0d97648ea6b9d7619bc3d656de866e/checks?check_suite_id=311492401#step:5:76)

```

Windows original main args:
wwwd_args[0] = java
wwwd_args[1] = --module-path=mods
wwwd_args[2] = --module=com.greetings/com.greetings.Main
wwwd_args[3] = --help
----_JAVA_LAUNCHER_DEBUG----
Launcher state:
	First application arg index: -1
	debug:on
	javargs:off
	program name:java
	launcher name:openjdk
	javaw:off
	fullversion:11.0.5+10-LTS
Java args:
Command line args:
argv[0] = java
argv[1] = --module-path=mods
argv[2] = --module=com.greetings/com.greetings.Main
argv[3] = --help
JRE path is C:\hostedtoolcache\windows\Java\11.0.5\x64
jvm.cfg[0] = ->-server<-
jvm.cfg[1] = ->-client<-
73 micro seconds to parse jvm.cfg
Default VM: server
JVM path is C:\hostedtoolcache\windows\Java\11.0.5\x64\bin\server\jvm.dll
JRE path is C:\hostedtoolcache\windows\Java\11.0.5\x64
CRT path is C:\hostedtoolcache\windows\Java\11.0.5\x64\bin\vcruntime140.dll
JRE path is C:\hostedtoolcache\windows\Java\11.0.5\x64
PRT path is C:\hostedtoolcache\windows\Java\11.0.5\x64\bin\msvcp140.dll
2803 micro seconds to LoadJavaVM
JavaVM args:
    version 0x00010002, ignoreUnrecognized is JNI_FALSE, nOptions is 5
    option[ 0] = '-Dsun.java.launcher.diag=true'
    option[ 1] = '--module-path=mods'
    option[ 2] = '-Djdk.module.main=com.greetings'
    option[ 3] = '-Dsun.java.command=com.greetings/com.greetings.Main --help'
    option[ 4] = '-Dsun.java.launcher=SUN_STANDARD'
176292 micro seconds to InitializeJVM
##[error]Process completed with exit code -1073741819.
```

First application arg index: `-1` with `argv[3] = --help`. ❌

## With `=` ... sometimes, the launcher recovers with a warning

`java --module-path=mods --module=com.greetings/com.greetings.Main --help`

[Step 5, Line 76](https://github.com/sormuras/JDK-8234076/runs/303538563#step:5:76)

```
...
Module is 'com.greetings/com.greetings.Main'
App's argc is 1
    argv[ 0] = '--help'
5350 micro seconds to load main class
----_JAVA_LAUNCHER_DEBUG----
AppArgIndex: -1 points to (null)
Warning: app args count doesn't match, 5 1
passing arguments as-is.
Greetings! [--help]
```

I guess, this may lead to spurious runtime errors, like described here: https://github.com/remkop/picocli/issues/863

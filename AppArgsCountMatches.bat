set _JAVA_LAUNCHER_DEBUG=true
javac -d mods --module-source-path src --module com.greetings
java --module-path=mods --module com.greetings/com.greetings.Main --help

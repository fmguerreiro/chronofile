MAKEFLAGS += --silent

.PHONY: apk
apk:
	# Gradle requires Java 17+
	PATH="/opt/android-studio/jbr/bin:${PATH}" ./gradlew assembleRelease
	find app -name '*.apk' | grep release

.PHONY: log
log:
	adb logcat -s -v time,color AndroidRuntime Chronofile \
	  | sed -uE 's/ .\/[A-Za-z]+\([0-9]+\)://' \
	  | sed -uE 's/[0-9]{2}-[0-9]{2} ([0-9]{2}:[0-9]{2}:[0-9]{2})/\1/'

.PHONY: deploy
deploy:
	# Fast deployment with daemon
	export JAVA_HOME=$$(/usr/libexec/java_home -v 17) && ./gradlew installDebug --daemon
	adb shell am start -n com.chaidarun.chronofile/.MainActivity

.PHONY: build
build:
	# Fast build with daemon
	export JAVA_HOME=$$(/usr/libexec/java_home -v 17) && ./gradlew assembleDebug --daemon

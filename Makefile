
GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.0.15

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:8.0

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = test8Ball
test8Ball_CFLAGS = -fobjc-arc
test8Ball_FILES = test8Ball.x test8BallHelper.m
test8Ball_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 pool"

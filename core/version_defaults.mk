#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Handle various build version information.
#
# Guarantees that the following are defined:
#     PLATFORM_VERSION
#     PLATFORM_DISPLAY_VERSION
#     PLATFORM_SDK_VERSION
#     PLATFORM_VERSION_CODENAME
#     DEFAULT_APP_TARGET_SDK
#     BUILD_ID
#     BUILD_NUMBER
#     PLATFORM_SECURITY_PATCH
#     PLATFORM_VNDK_VERSION
#     PLATFORM_SYSTEMSDK_VERSIONS
#

# Look for an optional file containing overrides of the defaults,
# but don't cry if we don't find it.  We could just use -include, but
# the build.prop target also wants INTERNAL_BUILD_ID_MAKEFILE to be set
# if the file exists.
#
INTERNAL_BUILD_ID_MAKEFILE := $(wildcard $(BUILD_SYSTEM)/build_id.mk)
ifdef INTERNAL_BUILD_ID_MAKEFILE
  include $(INTERNAL_BUILD_ID_MAKEFILE)
endif

DEFAULT_PLATFORM_VERSION := TP1A
.KATI_READONLY := DEFAULT_PLATFORM_VERSION
MIN_PLATFORM_VERSION := TP1A
MAX_PLATFORM_VERSION := TP1A

# The last stable version name of the platform that was released.  During
# development, this stays at that previous version, while the codename indicates
# further work based on the previous version.
PLATFORM_VERSION_LAST_STABLE := 13
.KATI_READONLY := PLATFORM_VERSION_LAST_STABLE

# These are the current development codenames, if the build is not a final
# release build.  If this is a final release build, it is simply "REL".
PLATFORM_VERSION_CODENAME.TP1A := REL

<<<<<<< HEAD   (f20099 Version bump to TP1A.220624.021.A1 [core/build_id.mk])
# This is the user-visible version.  In a final release build it should
# be empty to use PLATFORM_VERSION as the user-visible version.  For
# a preview release it can be set to a user-friendly value like `12 Preview 1`
PLATFORM_DISPLAY_VERSION := 13
=======
ifndef PLATFORM_VERSION_CODENAME
  PLATFORM_VERSION_CODENAME := $(PLATFORM_VERSION_CODENAME.$(TARGET_PLATFORM_VERSION))
  ifndef PLATFORM_VERSION_CODENAME
    # PLATFORM_VERSION_CODENAME falls back to TARGET_PLATFORM_VERSION
    PLATFORM_VERSION_CODENAME := $(TARGET_PLATFORM_VERSION)
  endif

  # This is all of the *active* development codenames.
  # This confusing name is needed because
  # all_codenames has been baked into build.prop for ages.
  #
  # Should be either the same as PLATFORM_VERSION_CODENAME or a comma-separated
  # list of additional codenames after PLATFORM_VERSION_CODENAME.
  PLATFORM_VERSION_ALL_CODENAMES :=

  # Build a list of all active code names. Avoid duplicates, and stop when we
  # reach a codename that matches PLATFORM_VERSION_CODENAME (anything beyond
  # that is not included in our build).
  _versions_in_target := \
    $(call find_and_earlier,$(ALL_VERSIONS),$(TARGET_PLATFORM_VERSION))
  $(foreach version,$(_versions_in_target),\
    $(eval _codename := $(PLATFORM_VERSION_CODENAME.$(version)))\
    $(if $(filter $(_codename),$(PLATFORM_VERSION_ALL_CODENAMES)),,\
      $(eval PLATFORM_VERSION_ALL_CODENAMES += $(_codename))))

  # And convert from space separated to comma separated.
  PLATFORM_VERSION_ALL_CODENAMES := \
    $(subst $(space),$(comma),$(strip $(PLATFORM_VERSION_ALL_CODENAMES)))

endif
.KATI_READONLY := \
  PLATFORM_VERSION_CODENAME \
  PLATFORM_VERSION_ALL_CODENAMES

ifndef PLATFORM_VERSION
  ifeq (REL,$(PLATFORM_VERSION_CODENAME))
      PLATFORM_VERSION := $(PLATFORM_VERSION_LAST_STABLE)
  else
      PLATFORM_VERSION := $(PLATFORM_VERSION_CODENAME)
  endif
endif
>>>>>>> CHANGE (7647eb Allow version and security patch to be changed)

ifndef PLATFORM_SDK_VERSION
  # This is the canonical definition of the SDK version, which defines
  # the set of APIs and functionality available in the platform.  It
  # is a single integer that increases monotonically as updates to
  # the SDK are released.  It should only be incremented when the APIs for
  # the new release are frozen (so that developers don't write apps against
  # intermediate builds).  During development, this number remains at the
  # SDK version the branch is based on and PLATFORM_VERSION_CODENAME holds
  # the code-name of the new development work.

  # When you increment the PLATFORM_SDK_VERSION please ensure you also
  # clear out the following text file of all older PLATFORM_VERSION's:
  # cts/tests/tests/os/assets/platform_versions.txt
  PLATFORM_SDK_VERSION := 33
endif
.KATI_READONLY := PLATFORM_SDK_VERSION

# This is the sdk extension version of this tree.
PLATFORM_SDK_EXTENSION_VERSION := 3
.KATI_READONLY := PLATFORM_SDK_EXTENSION_VERSION

# This is the sdk extension version that PLATFORM_SDK_VERSION ships with.
PLATFORM_BASE_SDK_EXTENSION_VERSION := 3
.KATI_READONLY := PLATFORM_BASE_SDK_EXTENSION_VERSION

# This are all known codenames.
PLATFORM_VERSION_KNOWN_CODENAMES := \
Base Base11 Cupcake Donut Eclair Eclair01 EclairMr1 Froyo Gingerbread GingerbreadMr1 \
Honeycomb HoneycombMr1 HoneycombMr2 IceCreamSandwich IceCreamSandwichMr1 \
JellyBean JellyBeanMr1 JellyBeanMr2 Kitkat KitkatWatch Lollipop LollipopMr1 M N NMr1 O OMr1 P \
Q R S Sv2 Tiramisu

# Convert from space separated list to comma separated
PLATFORM_VERSION_KNOWN_CODENAMES := \
  $(call normalize-comma-list,$(PLATFORM_VERSION_KNOWN_CODENAMES))
.KATI_READONLY := PLATFORM_VERSION_KNOWN_CODENAMES

ifndef PLATFORM_SECURITY_PATCH
    #  Used to indicate the security patch that has been applied to the device.
    #  It must signify that the build includes all security patches issued up through the designated Android Public Security Bulletin.
    #  It must be of the form "YYYY-MM-DD" on production devices.
    #  It must match one of the Android Security Patch Level strings of the Public Security Bulletins.
    #  If there is no $PLATFORM_SECURITY_PATCH set, keep it empty.
<<<<<<< HEAD   (f20099 Version bump to TP1A.220624.021.A1 [core/build_id.mk])
    PLATFORM_SECURITY_PATCH := 2022-08-05
=======
      PLATFORM_SECURITY_PATCH := 2021-10-05
endif

ifndef PLATFORM_SECURITY_PATCH_TIMESTAMP
  # Used to indicate the matching timestamp for the security patch string in PLATFORM_SECURITY_PATCH.
  PLATFORM_SECURITY_PATCH_TIMESTAMP := $(shell date -d 'TZ="GMT" $(PLATFORM_SECURITY_PATCH)' +%s)
endif
.KATI_READONLY := PLATFORM_SECURITY_PATCH_TIMESTAMP

ifndef PLATFORM_BASE_OS
  # Used to indicate the base os applied to the device.
  # Can be an arbitrary string, but must be a single word.
  #
  # If there is no $PLATFORM_BASE_OS set, keep it empty.
  PLATFORM_BASE_OS :=
endif
.KATI_READONLY := PLATFORM_BASE_OS

ifndef BUILD_ID
  # Used to signify special builds.  E.g., branches and/or releases,
  # like "M5-RC7".  Can be an arbitrary string, but must be a single
  # word and a valid file name.
  #
  # If there is no BUILD_ID set, make it obvious.
  BUILD_ID := UNKNOWN
endif
.KATI_READONLY := BUILD_ID

ifndef BUILD_DATETIME
  # Used to reproduce builds by setting the same time. Must be the number
  # of seconds since the Epoch.
  BUILD_DATETIME := $(shell date +%s)
>>>>>>> CHANGE (7647eb Allow version and security patch to be changed)
endif

include $(BUILD_SYSTEM)/version_util.mk

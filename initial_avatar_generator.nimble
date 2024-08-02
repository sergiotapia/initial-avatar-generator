# Package

version       = "0.1.1"
author        = "Sergio Tapia"
description   = "Generate an avatar image for a user based on their initials"
license       = "MIT"
srcDir        = "src"
bin           = @["initial_avatar_generator"]


# Dependencies

requires "nim >= 2.0.4"
requires "pixie"
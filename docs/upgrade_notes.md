Getting from Ruby 2.8 to 3.2
gem install ffi -v '1.9.25' -- --with-cflags="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types"

gem install pg -v '1.1.3' -- --with-cflags="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types"

gem install jaro_winkler -v '1.5.2' -- --with-cflags="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types"


Getting rspec running again

require File.expand_path('../config/environment', __dir__) no implicit conversion of String into Integer

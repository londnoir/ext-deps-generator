if ($args.Count -lt 2 -or [string]::IsNullOrEmpty($args[0]) -or [string]::IsNullOrEmpty($args[1])) {
	Write-Host "Bad call : BuildScript {x86_64|arm} {Release|Debug}`n"
	exit 1
}

$LIB_NAME = "harfbuzz"
$PLATFORM = "windows." + $args[0]
$BUILD_TYPE = $args[1]

$SOURCE_DIR = "./repositories/$LIB_NAME"
$BUILD_DIR = "./builds/$PLATFORM-$BUILD_TYPE/$LIB_NAME"
$INSTALL_DIR = "./output/$PLATFORM-$BUILD_TYPE"

if ($BUILD_TYPE -eq "Debug") {
	$MSVC_RUNTIME = "MultiThreadedDebug"
} else {
	$MSVC_RUNTIME = "MultiThreaded"
}

Write-Host "`n======================== Configuring '$LIB_NAME' for '$PLATFORM-$BUILD_TYPE' ... ========================`n"

cmake -S $SOURCE_DIR -B $BUILD_DIR -G "Visual Studio 17 2022" -A x64 `
-DCMAKE_BUILD_TYPE="$BUILD_TYPE" `
-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" `
-DCMAKE_MSVC_RUNTIME_LIBRARY="$MSVC_RUNTIME" `
-DCMAKE_C_FLAGS_RELEASE="/MT" `
-DCMAKE_C_FLAGS_DEBUG="/MTd" `
-DCMAKE_CXX_FLAGS_RELEASE="/MT" `
-DCMAKE_CXX_FLAGS_DEBUG="/MTd" `
-DBUILD_SHARED_LIBS=Off `
-DHB_HAVE_CAIRO=Off `
-DHB_HAVE_FREETYPE=Off `
-DHB_HAVE_GRAPHITE2=Off `
-DHB_HAVE_GLIB=Off `
-DHB_HAVE_ICU=Off `
-DHB_BUILD_UTILS=Off `
-DHB_BUILD_SUBSET=On `
-DHB_HAVE_GOBJECT=Off `
-DHB_HAVE_INTROSPECTION=Off `
-DHB_HAVE_UNISCRIBE=Off `
-DHB_HAVE_GDI=Off `
-DHB_HAVE_DIRECTWRITE=Off

Write-Host "`n======================== Building ... ========================`n"

cmake --build $BUILD_DIR --config $BUILD_TYPE

Write-Host "`n======================== Installing ... ========================`n"

cmake --install $BUILD_DIR --config $BUILD_TYPE

Write-Host "`n======================== Success ! ========================`n"

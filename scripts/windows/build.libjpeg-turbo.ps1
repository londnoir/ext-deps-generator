if ($args.Count -lt 2 -or [string]::IsNullOrEmpty($args[0]) -or [string]::IsNullOrEmpty($args[1])) {
	Write-Host "Bad call : BuildScript {x86_64|arm} {Release|Debug}`n"
	exit 1
}

$LIB_NAME = "libjpeg-turbo"
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
-DENABLE_SHARED=Off `
-DENABLE_STATIC=On `
-DREQUIRE_SIMD=Off `
-DWITH_ARITH_DEC=On `
-DWITH_ARITH_ENC=On `
-DWITH_JAVA=Off `
-DWITH_JPEG7=Off `
-DWITH_JPEG8=Off `
-DWITH_SIMD=On `
-DWITH_TURBOJPEG=On `
-DWITH_FUZZ=Off

Write-Host "`n======================== Building ... ========================`n"

cmake --build $BUILD_DIR --config $BUILD_TYPE

Write-Host "`n======================== Installing ... ========================`n"

cmake --install $BUILD_DIR --config $BUILD_TYPE

Write-Host "`n======================== Success ! ========================`n"

Pod::Spec.new do |spec|
spec.name = 'shared'
spec.version = '1.1'
spec.homepage = 'https://github.com/feliperce/KaMPKit/tree/master/shared'
spec.source = { :git => "https://github.com/feliperce/KaMPKit/tree/master/shared" }
spec.authors = 'Felipe and Juan'
spec.license = 'Alguma coisa para nao deixar empty'
spec.summary = 'SDK que vai fazer as chamadas ao onboarding'
spec.vendored_frameworks = "build/cocoapods/framework/shared.framework"
spec.libraries = "c++"
spec.module_name = "#{spec.name}_umbrella"
spec.pod_target_xcconfig = {
'KOTLIN_TARGET[sdk=iphonesimulator*]' => 'ios_x64',
'KOTLIN_TARGET[sdk=iphoneos*]' => 'ios_arm',
'KOTLIN_TARGET[sdk=watchsimulator*]' => 'watchos_x86',
'KOTLIN_TARGET[sdk=watchos*]' => 'watchos_arm',
'KOTLIN_TARGET[sdk=appletvsimulator*]' => 'tvos_x64',
'KOTLIN_TARGET[sdk=appletvos*]' => 'tvos_arm64',
'KOTLIN_TARGET[sdk=macosx*]' => 'macos_x64'
}
spec.script_phases = [
{
:name => 'Build shared',
:execution_position => :before_compile,
:shell_path => '/bin/sh',
:script => <<-SCRIPT
set -ev
REPO_ROOT="$PODS_TARGET_SRCROOT"
"$REPO_ROOT/../gradlew" -p "$REPO_ROOT" :shared:syncFramework \
-Pkotlin.native.cocoapods.target=$KOTLIN_TARGET \
-Pkotlin.native.cocoapods.configuration=$CONFIGURATION \
-Pkotlin.native.cocoapods.cflags="$OTHER_CFLAGS" \
-Pkotlin.native.cocoapods.paths.headers="$HEADER_SEARCH_PATHS" \
-Pkotlin.native.cocoapods.paths.frameworks="$FRAMEWORK_SEARCH_PATHS"
SCRIPT
},
{
:name => 'Touch shared.framework',
:execution_position => :after_compile,
:shell_path => '/bin/sh',
:script => 'find "${SRCROOT}" -type f -name *frameworks.sh -exec bash -c "touch \"{}\"" \;'
}
]
end
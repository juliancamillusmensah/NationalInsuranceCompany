# Portability-ready Compilation Script
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
Set-Location $PSScriptRoot

# 1. Resolve Application Home (Current Directory)
$appHome = $PSScriptRoot
$classesDir = "$appHome\WEB-INF\classes"
$libDir = "$appHome\WEB-INF\lib"
$srcDir = "$appHome\src"

# 2. Locate Tomcat Libraries (required for Servlet API)
# Priority 1: Check environment variable if set
$tomcatHome = $env:CATALINA_HOME
if (-not $tomcatHome) {
    # Priority 2: Try to find Tomcat relative to webapps folder (usual structure)
    $potentialTomcat = Split-Path -Parent (Split-Path -Parent $appHome)
    if (Test-Path "$potentialTomcat\lib\servlet-api.jar") {
        $tomcatHome = $potentialTomcat
    } else {
        # Fallback: Common Windows installation path
        $tomcatHome = "C:\Program Files\Apache Software Foundation\Tomcat 10.1"
    }
}

Write-Host "Project Root: $appHome"
Write-Host "Tomcat Home:  $tomcatHome"

if (-not (Test-Path $classesDir)) {
    New-Item -ItemType Directory -Path $classesDir -Force | Out-Null
}

# 3. Construct Classpath
$classpath = "$libDir\*"
if (Test-Path "$tomcatHome\lib\servlet-api.jar") {
    $classpath += ";$tomcatHome\lib\*"
}

# 4. Compile
$sources = Get-ChildItem -Path $srcDir -Filter *.java -Recurse | ForEach-Object { "$($_.FullName)" }

if ($sources) {
    & javac -d "$classesDir" -cp "$classpath" $sources
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success: Compilation complete. All classes in WEB-INF/classes" -ForegroundColor Green
    } else {
        Write-Error "Error: Compilation failed."
    }
} else {
    Write-Warning "No source files found in $srcDir"
}

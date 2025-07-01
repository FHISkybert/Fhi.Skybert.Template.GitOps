# Pre-commit hook to validate Helm templates (PowerShell version)
# For Windows PowerShell users

param()

Write-Host "Running Helm template validation..." -ForegroundColor Green

# Check if Helm is installed
try {
    $helmVersion = helm version --short 2>$null
    if (-not $helmVersion) {
        Write-Host "Error: Helm is not installed. Please install Helm 3.x first." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error: Helm is not installed. Please install Helm 3.x first." -ForegroundColor Red
    exit 1
}

# Find all non-hidden directories in the root that contain Chart.yaml
$envs = Get-ChildItem -Directory | Where-Object { 
    $_.Name -notmatch '^\.' -and 
    $_.Name -ne '.git' -and 
    $_.Name -ne '.github' -and
    (Test-Path (Join-Path $_.FullName "Chart.yaml"))
} | Select-Object -ExpandProperty Name

Write-Host "Found environments: $($envs -join ' ')" -ForegroundColor Yellow

$errors = 0

foreach ($env in $envs) {
    Write-Host "Validating environment: $env" -ForegroundColor Cyan
    
    # Update Helm dependencies for this environment
    Write-Host "  Updating dependencies..." -ForegroundColor Gray
    Push-Location $env
    try {
        helm dependency update 2>$null | Out-Null
        
        # Test Helm template generation
        Write-Host "  Testing template generation..." -ForegroundColor Gray
        helm template test . 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ $env : Templates are valid" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $env : Template validation failed" -ForegroundColor Red
            Write-Host "     Run 'helm template test .' in the $env directory to see errors" -ForegroundColor Yellow
            $errors++
        }
        
        # Clean up generated files
        Write-Host "  Cleaning up..." -ForegroundColor Gray
        if (Test-Path "Chart.lock") { Remove-Item "Chart.lock" -Force }
        if (Test-Path "charts") { Remove-Item "charts" -Recurse -Force }
        
    } catch {
        Write-Host "  ❌ $env : Template validation failed" -ForegroundColor Red
        Write-Host "     Run 'helm dependency update' in the $env directory to see errors" -ForegroundColor Yellow
        $errors++
        
        # Clean up even if there was an error
        if (Test-Path "Chart.lock") { Remove-Item "Chart.lock" -Force }
        if (Test-Path "charts") { Remove-Item "charts" -Recurse -Force }
    } finally {
        Pop-Location
    }
}

if ($errors -eq 0) {
    Write-Host ""
    Write-Host "✅ All Helm templates are valid!" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "❌ $errors environment(s) have template errors. Please fix before committing." -ForegroundColor Red
    exit 1
} 
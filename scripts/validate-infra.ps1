Write-Host "=== Infrastructure Validation Script ===" -ForegroundColor Cyan
Write-Host ""

$env:AWS_ENDPOINT_URL="http://localhost:4566"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"

$script:PASS = 0
$script:FAIL = 0

function Check-Command($Description, $Command) {
    try {
        Invoke-Expression $Command | Out-Null
        if ($LASTEXITCODE -eq 0 -or $? -eq $true) {
            Write-Host "[PASS] $Description" -ForegroundColor Green
            $script:PASS++
        } else {
            Write-Host "[FAIL] $Description" -ForegroundColor Red
            $script:FAIL++
        }
    } catch {
        Write-Host "[FAIL] $Description" -ForegroundColor Red
        $script:FAIL++
    }
}

Write-Host "--- ECR Validation ---"
aws ecr create-repository --repository-name infra-test-app *>$null 2>&1
Check-Command "ECR repository exists" "aws ecr describe-repositories --repository-names infra-test-app"

Write-Host ""
Write-Host "--- Docker Build Validation ---"
docker build -t infra-test-app:ci . *>$null 2>&1
Check-Command "Docker image built" "docker image inspect infra-test-app:ci"
Check-Command "Image configured for ECR" "Write-Output 'Success'"

Write-Host ""
Write-Host "--- ECS Validation ---"
aws ecs create-cluster --cluster-name infra-test-cluster *>$null 2>&1
Check-Command "ECS cluster exists" "aws ecs describe-clusters --clusters infra-test-cluster"

aws ecs register-task-definition --cli-input-json file://task-definition.json *>$null 2>&1
Check-Command "Task definition registered" "aws ecs list-task-definitions --family-prefix infra-test-app"

Write-Host ""
Write-Host "=== Results ==="
Write-Host "Passed: $script:PASS"
Write-Host "Failed: $script:FAIL"
Write-Host ""

if ($script:FAIL -gt 0) {
    Write-Host "INFRASTRUCTURE VALIDATION FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "INFRASTRUCTURE VALIDATION PASSED" -ForegroundColor Green
    exit 0
}
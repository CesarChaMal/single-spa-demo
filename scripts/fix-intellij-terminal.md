# Fix IntelliJ Terminal PATH Issues

## Problem
AWS CLI works in regular Git Bash but not in IntelliJ's integrated terminal.

## Cause
IntelliJ's integrated terminal uses a different PATH environment than your system terminal.

## Solutions

### Option 1: Quick Fix (Temporary)
Run this in IntelliJ terminal:
```bash
# Add AWS CLI to PATH for current session
export PATH=$PATH:/c/Program\ Files/Amazon/AWSCLIV2
# or
export PATH=$PATH:/c/Program\ Files\ \(x86\)/Amazon/AWSCLIV2
```

### Option 2: Permanent Fix (IntelliJ Settings)

1. **Open IntelliJ IDEA**
2. **Go to**: File → Settings → Tools → Terminal
3. **Add Environment Variable**:
   - Name: `PATH`
   - Value: `%PATH%;C:\Program Files\Amazon\AWSCLIV2`
4. **Restart IntelliJ**

### Option 3: Use Custom Shell Path

1. **Go to**: File → Settings → Tools → Terminal
2. **Shell path**: Change from default to:
   ```
   cmd.exe /k "set PATH=%PATH%;C:\Program Files\Amazon\AWSCLIV2"
   ```

### Option 4: Use Regular Git Bash

Instead of IntelliJ terminal, use external Git Bash:
1. Open regular Git Bash
2. Navigate to your project: `cd /c/temp/single-spa-demo`
3. Run AWS commands there

## Find Your AWS CLI Location

Run this script to find where AWS CLI is installed:
```bash
./fix-aws-cli-path.bat
```

## Common AWS CLI Locations

- `C:\Program Files\Amazon\AWSCLIV2\`
- `C:\Program Files (x86)\Amazon\AWSCLIV2\`
- `C:\Users\{username}\AppData\Local\Programs\Python\Python*\Scripts\`

## Test AWS CLI

After fixing PATH, test with:
```bash
aws --version
aws sts get-caller-identity
```

## Alternative: Use Windows Terminal

If IntelliJ terminal keeps having issues:
1. Install Windows Terminal from Microsoft Store
2. Use it instead of IntelliJ's integrated terminal
3. It has better PATH handling
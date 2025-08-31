# Get AWS Info Manually (Without AWS CLI)

If AWS CLI isn't working in IntelliJ terminal, you can get your AWS information manually.

## Method 1: AWS Console (Web)

### Get AWS Account ID:
1. **Login to AWS Console**: https://console.aws.amazon.com/
2. **Click your name** in top-right corner
3. **Account ID** is shown in the dropdown (12 digits)
4. **Example**: `123456789012`

### Get AWS Region:
1. **Look at the URL** in AWS Console
2. **Region is in the URL**: `https://console.aws.amazon.com/s3/?region=us-west-2`
3. **Or check top-right corner** next to your name
4. **Example**: `us-west-2`, `eu-central-1`, `eu-west-1`

## Method 2: Use Regular Git Bash

Since AWS CLI works in your regular Git Bash:

1. **Open regular Git Bash** (not IntelliJ terminal)
2. **Run these commands**:
   ```bash
   # Get Account ID
   aws sts get-caller-identity --query "Account" --output text
   
   # Get Region
   aws configure get region
   
   # Get full info
   aws sts get-caller-identity
   ```

## Method 3: Check AWS Credentials File

Your AWS config is stored in files:

**Windows:**
```
C:\Users\{username}\.aws\config
C:\Users\{username}\.aws\credentials
```

**Content example:**
```ini
[default]
region = us-west-2
output = json
```

## Recommended Configuration

Once you have your AWS info, use these values:

```env
# Replace 123456789012 with your actual Account ID
S3_BUCKET=single-spa-demo-123456789012

# Replace us-west-2 with your actual region
AWS_REGION=us-west-2

# Choose any name you want
ORG_NAME=mycompany
# or
ORG_NAME=yourname
# or  
ORG_NAME=yourproject
```

## Example

If your AWS Account ID is `987654321098` and region is `eu-west-1`:

```env
S3_BUCKET=single-spa-demo-987654321098
AWS_REGION=eu-west-1
ORG_NAME=myproject
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
```

## Next Steps

1. **Get your AWS Account ID and Region** using any method above
2. **Choose an ORG_NAME** (your GitHub username, company name, etc.)
3. **Run**: `npm run deploy:setup`
4. **Enter the values** when prompted
const fs = require('fs');
const path = require('path');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log('🚀 Single-SPA Deployment Setup\n');
console.log('This script will help you configure deployment settings for your microfrontends.\n');

const questions = [
  {
    key: 'AWS_ACCESS_KEY_ID',
    prompt: 'Enter your AWS Access Key ID: ',
    required: true
  },
  {
    key: 'AWS_SECRET_ACCESS_KEY',
    prompt: 'Enter your AWS Secret Access Key: ',
    required: true,
    hidden: true
  },
  {
    key: 'S3_BUCKET',
    prompt: 'Enter your S3 bucket name (default: single-spa-demo): ',
    default: 'single-spa-demo'
  },
  {
    key: 'S3_REGION',
    prompt: 'Enter your S3 region (default: eu-central-1): ',
    default: 'eu-central-1'
  },
  {
    key: 'ORG_NAME',
    prompt: 'Enter your organization name (default: cesarchamal): ',
    default: 'cesarchamal'
  }
];

const config = {};
let currentQuestion = 0;

function askQuestion() {
  if (currentQuestion >= questions.length) {
    saveConfig();
    return;
  }

  const question = questions[currentQuestion];
  rl.question(question.prompt, (answer) => {
    if (!answer && question.required) {
      console.log('This field is required. Please try again.');
      askQuestion();
      return;
    }
    
    config[question.key] = answer || question.default || '';
    currentQuestion++;
    askQuestion();
  });
}

function saveConfig() {
  const envContent = Object.entries(config)
    .map(([key, value]) => `${key}=${value}`)
    .join('\n');

  fs.writeFileSync('.env', envContent);
  
  console.log('\n✅ Configuration saved to .env file');
  console.log('\n📝 Next steps:');
  console.log('1. Make sure AWS CLI is installed: https://aws.amazon.com/cli/');
  console.log('2. Run "npm run deploy:all" to deploy all microfrontends');
  console.log('3. Set up Travis CI with the same environment variables');
  
  rl.close();
}

askQuestion();
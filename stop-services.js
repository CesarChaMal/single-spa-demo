const { exec } = require('child_process');
const os = require('os');

console.log('Stopping Single-SPA Microfrontend Demo services...');

const ports = [9000, 9001, 9002, 9003];
const platform = os.platform();

function killPort(port) {
  return new Promise((resolve) => {
    let command;
    
    if (platform === 'win32') {
      command = `for /f "tokens=5" %a in ('netstat -aon ^| findstr :${port}') do taskkill /f /pid %a`;
    } else {
      command = `lsof -ti:${port} | xargs kill -9`;
    }
    
    exec(command, (error) => {
      if (!error) {
        console.log(`Stopped service on port ${port}`);
      }
      resolve();
    });
  });
}

async function stopAll() {
  console.log('Stopping services on ports 9000-9003...');
  
  await Promise.all(ports.map(killPort));
  
  // Kill remaining webpack processes
  const webpackKillCommand = platform === 'win32' 
    ? 'taskkill /f /im node.exe /fi "WINDOWTITLE eq webpack*"'
    : 'pkill -f "webpack"';
    
  exec(webpackKillCommand, () => {
    console.log('All services stopped.');
  });
}

stopAll();
const hre = require("hardhat");
const fs = require('fs');
const path = require('path');

const envs = ["VITE_BENDING_ADDRESS", "VITE_BENDING_MARKET_ADDRESS"];
const frontendPath = "C:/laragon/www/crypto-bender/.env";

const getEnvLines = (filePath) => {
  let lines = fs.readFileSync(filePath, 'utf8');
  lines = lines.split('\n');
  return lines;
} 

const saveEnvVar = () => {
  const envFilePath = path.resolve(__dirname, '..' ,'frontend', '.env.local');
  const FEPath = path.resolve(frontendPath);

  let lines = getEnvLines(envFilePath);
  const environmentValues = lines.reduce((lines, line) => {
    const envName = line.split("=")[0].trim()
    if (envs.includes(envName)) {
      lines[envName] = {
        name: envName,
        line: line
      };
    };
    return lines;
  }, {});
  
  lines = getEnvLines(FEPath);

  const indexes = lines.reduce((lines, line, index) => {
    const envName = line.split("=")[0].trim()
    if (envs.includes(envName)) {
      lines[envName] = index;
    };
    return lines;
  }, {});

  console.log(environmentValues);

  Object.values(environmentValues).forEach((env) => {
    lines.splice(indexes[env.name], 1, env.line);
  })

  fs.writeFileSync(FEPath, lines.join('\n'), (err) => {
    if (err) {
      console.log(err);
    }
  });
}

saveEnvVar()
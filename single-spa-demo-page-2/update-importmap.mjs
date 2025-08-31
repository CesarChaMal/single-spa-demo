// Note that this file requires node@13.2.0 or higher (or the --experimental-modules flag)
import fs from "fs";
import path from "path";
import https from "https";

const importMapFilePath = path.resolve(process.cwd(), "importmap.json");
let importMap;

// Initialize import map with shared dependencies if file doesn't exist or is empty
try {
  importMap = JSON.parse(fs.readFileSync(importMapFilePath));
} catch (error) {
  importMap = { imports: {} };
}

// Ensure shared dependencies are always present
if (!importMap.imports) importMap.imports = {};
if (!importMap.imports["single-spa"]) {
  importMap.imports["single-spa"] = "https://cdn.jsdelivr.net/npm/single-spa@5.9.0/lib/system/single-spa.min.js";
}
if (!importMap.imports["react"]) {
  importMap.imports["react"] = "https://cdn.jsdelivr.net/npm/react@16.13.1/umd/react.production.min.js";
}
if (!importMap.imports["react-dom"]) {
  importMap.imports["react-dom"] = "https://cdn.jsdelivr.net/npm/react-dom@16.13.1/umd/react-dom.production.min.js";
}
const s3Bucket = process.env.S3_BUCKET || 'single-spa-demo';
const awsRegion = process.env.AWS_REGION || 'eu-central-1';
const orgName = process.env.ORG_NAME || 'cesarchamal';
const commitSha = process.env.TRAVIS_COMMIT || process.env.GITHUB_SHA;
const url = `https://${s3Bucket}.s3-${awsRegion}.amazonaws.com/@${orgName}/single-spa-demo-page-2/${commitSha}/${orgName}-single-spa-demo-page-2.js`;

https
  .get(url, res => {
    // HTTP redirects (301, 302, etc) not currently supported, but could be added
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (
        res.headers["content-type"] &&
        res.headers["content-type"].toLowerCase().trim() ===
          "application/javascript"
      ) {
        const moduleName = `@${orgName}/single-spa-demo-page-2`;
        importMap.imports[moduleName] = url;
        fs.writeFileSync(importMapFilePath, JSON.stringify(importMap, null, 2));
        console.log(
          `Updated import map for module ${moduleName}. New url is ${url}.`
        );
      } else {
        urlNotDownloadable(
          url,
          Error(`Content-Type response header must be application/javascript`)
        );
      }
    } else {
      urlNotDownloadable(
        url,
        Error(`HTTP response status was ${res.statusCode}`)
      );
    }
  })
  .on("error", err => {
    urlNotDownloadable(url, err);
  });

function urlNotDownloadable(url, err) {
  throw Error(
    `Refusing to update import map - could not download javascript file at url ${url}. Error was '${err.message}'`
  );
}

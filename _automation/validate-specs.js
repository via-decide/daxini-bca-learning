const fs=require('fs');
const required=['docs/index.md','docs/learning-paths.md','docs/_shared/glossary.md'];
let bad=[];for(const f of required){if(!fs.existsSync(f)) bad.push(f)}
for(const d of ['docs/02-core-engineering/01-version-control','docs/02-core-engineering/02-package-management','docs/04-infrastructure/03-deployment-platforms']){const f=d+'/index.md'; if(!fs.existsSync(f)||!fs.readFileSync(f,'utf8').includes('## Exercises')) bad.push(f)}
if(bad.length){console.error('Missing or incomplete:',bad);process.exit(1)}
console.log('Specification validation passed');

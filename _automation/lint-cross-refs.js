const fs=require('fs');
const text=fs.readFileSync('docs/index.md','utf8');
for (const link of ['02-core-engineering/01-version-control/','02-core-engineering/02-package-management/','04-infrastructure/03-deployment-platforms/']) if(!text.includes(link)){console.error('Missing link '+link);process.exit(1)}
console.log('Cross-reference lint passed');

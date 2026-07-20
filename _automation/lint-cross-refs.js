const fs = require('fs');
const path = require('path');

const failures = [];
const docsIndex = fs.readFileSync('docs/index.md', 'utf8');
for (const link of [
  '02-core-engineering/01-version-control/',
  '02-core-engineering/02-package-management/',
  '04-infrastructure/03-deployment-platforms/',
]) {
  if (!docsIndex.includes(link)) failures.push(`docs/index.md missing ${link}`);
}

const { modules } = JSON.parse(fs.readFileSync('_automation/module-specifications-5-27.json', 'utf8'));
for (const mod of modules) {
  const relative = mod.folder.replace(/^docs\//, '') + '/';
  if (!docsIndex.includes(relative)) failures.push(`docs/index.md missing ${relative}`);
  for (const fileName of mod.files) {
    const file = path.join(mod.folder, fileName);
    if (!fs.existsSync(file)) failures.push(`Missing cross-reference target ${file}`);
  }
}

if (failures.length) {
  console.error(failures.join('\n'));
  process.exit(1);
}
console.log('Cross-reference lint passed');

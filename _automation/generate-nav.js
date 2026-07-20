const fs = require('fs');
const { modules } = require('./module-specifications-5-27.json');

const base = [
  { id: 1, name: 'Version Control & Collaboration', folder: 'docs/02-core-engineering/01-version-control' },
  { id: 2, name: 'Package Management', folder: 'docs/02-core-engineering/02-package-management' },
  { id: 3, name: 'Deployment Platforms', folder: 'docs/04-infrastructure/03-deployment-platforms' },
  ...modules,
];
const byCategory = new Map();
for (const mod of base) {
  const category = mod.category || mod.folder.split('/')[1];
  if (!byCategory.has(category)) byCategory.set(category, []);
  byCategory.get(category).push(mod);
}
let nav = '# Sidebar Navigation\n\n';
for (const [category, items] of [...byCategory.entries()].sort()) {
  nav += `- ${category}\n`;
  for (const mod of items.sort((a, b) => a.id - b.id)) {
    nav += `  - [${mod.id}. ${mod.name}](${mod.folder.replace(/^docs\//, '')}/)\n`;
  }
}
fs.writeFileSync('docs/_shared/sidebar.md', nav);
console.log('Generated docs/_shared/sidebar.md');

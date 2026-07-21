const fs = require('fs');
const path = require('path');

const requiredTopLevel = ['docs/index.md', 'docs/learning-paths.md', 'docs/_shared/glossary.md'];
const batchPath = '_automation/module-specifications-5-27.json';
const requiredSections = [
  '## 1. Repository Context',
  '## 2. Learning Objectives',
  '## 3. Prerequisites',
  '## 4. Required Chapter Structure',
  '## 5. Mandatory Concepts',
  '## 6. Internal Knowledge Graph',
  '## 7. Required Diagrams',
  '## 8. Practical Examples',
  '## 9. Required Code',
  '## 10. Exercises',
  '## 11. Glossary Requirements',
  '## 12. Cross References',
  '## 13. Documentation Constraints',
  '## 14. Acceptance Criteria',
];

const failures = [];
for (const file of requiredTopLevel) {
  if (!fs.existsSync(file)) failures.push(`Missing required file: ${file}`);
}

for (const moduleDir of [
  'docs/02-core-engineering/01-version-control',
  'docs/02-core-engineering/02-package-management',
  'docs/04-infrastructure/03-deployment-platforms',
]) {
  const indexFile = path.join(moduleDir, 'index.md');
  if (!fs.existsSync(indexFile) || !fs.readFileSync(indexFile, 'utf8').includes('## Exercises')) {
    failures.push(`Missing legacy module exercise section: ${indexFile}`);
  }
}

if (!fs.existsSync(batchPath)) {
  failures.push(`Missing batch specification data: ${batchPath}`);
} else {
  const { modules } = JSON.parse(fs.readFileSync(batchPath, 'utf8'));
  for (const mod of modules) {
    for (const fileName of mod.files) {
      const file = path.join(mod.folder, fileName);
      if (!fs.existsSync(file)) failures.push(`Missing module file: ${file}`);
      if (fileName === 'index.md' && fs.existsSync(file)) {
        const text = fs.readFileSync(file, 'utf8');
        for (const section of requiredSections) {
          if (!text.includes(section)) failures.push(`Missing section ${section} in ${file}`);
        }
        for (const section of mod.sections) {
          for (const concept of section.concepts) {
            if (!text.includes(concept)) failures.push(`Missing concept ${concept} in ${file}`);
          }
        }
      }
    }
  }
}

if (failures.length) {
  console.error(failures.join('\n'));
  process.exit(1);
}
console.log('Specification validation passed');

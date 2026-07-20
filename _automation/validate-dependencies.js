const map = require('./reference-map.json');
const { modules } = require('./module-specifications-5-27.json');
const failures = [];
if (!map['1-version-control']) failures.push('Missing module 1 dependency map');
for (const mod of modules) {
  const key = `${mod.id}-${mod.folder.split('/').pop().replace(/^\d+-/, '')}`;
  if (!map[key]) failures.push(`Missing dependency map entry: ${key}`);
  for (const prereq of mod.prerequisites) {
    if (prereq === mod.id) failures.push(`Module ${mod.id} depends on itself`);
  }
}
if (failures.length) {
  console.error(failures.join('\n'));
  process.exit(1);
}
console.log('Dependency map validation passed');

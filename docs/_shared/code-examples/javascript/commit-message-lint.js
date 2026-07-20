const message = process.argv.slice(2).join(' ').trim();
const ok = /^(feat|fix|docs|chore|refactor|test)(\([a-z0-9-]+\))?: .{10,}$/.test(message);
if (!ok) {
  console.error('Use conventional commits, e.g. feat(auth): add login validation');
  process.exit(1);
}
console.log('Commit message is valid');

const fs=require('fs');
const examples=['docs/_shared/code-examples/bash/git-branch-name.sh','docs/_shared/code-examples/javascript/commit-message-lint.js'];
for(const f of examples) if(!fs.existsSync(f)){console.error('Missing example '+f);process.exit(1)}
console.log('Example checks passed');

#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const TOPICS_FILE = path.join(ROOT, 'data', 'knowledge-topics.json');
const INDEX_FILE = path.join(ROOT, 'knowledge-index.json');
const GRAPH_FILE = path.join(ROOT, 'knowledge-graph.json');
const VIS_FILE = path.join(ROOT, 'knowledge-graph-visualization.json');
const REPORT_FILE = path.join(ROOT, 'knowledge-engine-report.json');

const REQUIRED_FIELDS = [
  'id','title','subject','semester','unit','difficulty','learningTimeHours','prerequisites',
  'conceptsRequired','conceptsEnabled','practicalApplications','industryUsage','interviewFrequency',
  'examFrequency','importantFormulae','algorithms','commonMistakes','relatedExperiments',
  'programmingExamples','externalReferences','revisionPriority','tags'
];
const SUPPORTED_EXTENSIONS = new Set(['.md', '.pdf', '.png', '.jpg', '.jpeg', '.webp', '.ppt', '.pptx', '.js', '.jsx', '.ts', '.tsx', '.py', '.java', '.c', '.cpp', '.sql']);
const IGNORE_DIRS = new Set(['.git', 'node_modules']);
const frequencyWeight = { High: 3, Medium: 2, Low: 1 };
const OPTIONAL_EMPTY_ARRAY_FIELDS = new Set(['prerequisites', 'conceptsRequired', 'conceptsEnabled', 'importantFormulae']);

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2) + '\n');
}

function walk(dir, files = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (IGNORE_DIRS.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full, files);
    else if (SUPPORTED_EXTENSIONS.has(path.extname(entry.name).toLowerCase())) files.push(full);
  }
  return files;
}

function safeReadText(file) {
  const ext = path.extname(file).toLowerCase();
  if (!['.md', '.js', '.jsx', '.ts', '.tsx', '.py', '.java', '.c', '.cpp', '.sql'].includes(ext)) return '';
  return fs.readFileSync(file, 'utf8').slice(0, 200000).toLowerCase();
}

function tokenize(value) {
  return String(value).toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim().split(/\s+/).filter(Boolean);
}

function topicKeywords(topic) {
  return Array.from(new Set([
    ...tokenize(topic.title), ...tokenize(topic.subject), ...(topic.tags || []).flatMap(tokenize),
    ...(topic.algorithms || []).flatMap(tokenize), ...(topic.programmingExamples || []).flatMap(tokenize)
  ].filter(word => word.length > 2)));
}

function classifyAsset(file) {
  const relativePath = path.relative(ROOT, file).replaceAll(path.sep, '/');
  const ext = path.extname(file).toLowerCase();
  if (relativePath.includes('syllabus')) return 'university syllabus';
  if (relativePath.includes('paper') || relativePath.includes('exam')) return 'previous-year paper';
  if (relativePath.includes('practical') || relativePath.includes('lab')) return 'lab manual/practical';
  if (['.ppt', '.pptx'].includes(ext)) return 'presentation';
  if (['.png', '.jpg', '.jpeg', '.webp'].includes(ext)) return 'image';
  if (ext === '.pdf') return 'pdf';
  if (['.js', '.jsx', '.ts', '.tsx', '.py', '.java', '.c', '.cpp', '.sql'].includes(ext)) return 'code example';
  if (relativePath.includes('resources/') || relativePath.includes('guides/')) return 'external/reference note';
  if (relativePath.includes('projects/')) return 'project guide';
  return 'markdown note';
}

function linkAssetsToTopics(assets, topics) {
  const keywordMap = new Map(topics.map(topic => [topic.id, topicKeywords(topic)]));
  return assets.map(asset => {
    const text = safeReadText(path.join(ROOT, asset.path));
    const haystack = `${asset.path.toLowerCase()} ${text}`;
    const relatedTopics = topics
      .map(topic => {
        const score = keywordMap.get(topic.id).reduce((sum, keyword) => sum + (haystack.includes(keyword) ? 1 : 0), 0);
        return { id: topic.id, score };
      })
      .filter(link => link.score >= 2)
      .sort((a, b) => b.score - a.score || a.id.localeCompare(b.id))
      .slice(0, 8)
      .map(link => link.id);
    return { ...asset, relatedTopics };
  });
}

function validateTopics(topics) {
  const ids = new Set(topics.map(topic => topic.id));
  const duplicateTopics = topics
    .map(topic => topic.title.toLowerCase().trim())
    .filter((title, index, all) => all.indexOf(title) !== index);
  const brokenPrerequisites = [];
  const missingFields = [];
  for (const topic of topics) {
    for (const field of REQUIRED_FIELDS) {
      if (!(field in topic) || topic[field] === '' || (Array.isArray(topic[field]) && topic[field].length === 0 && !OPTIONAL_EMPTY_ARRAY_FIELDS.has(field))) {
        missingFields.push({ topicId: topic.id, field });
      }
    }
    for (const prereq of topic.prerequisites || []) {
      if (!ids.has(prereq)) brokenPrerequisites.push({ topicId: topic.id, missingPrerequisite: prereq });
    }
  }
  return { duplicateTopics: Array.from(new Set(duplicateTopics)), brokenPrerequisites, missingFields };
}

function buildEdges(topics) {
  const edges = [];
  const byId = new Map(topics.map(topic => [topic.id, topic]));
  for (const topic of topics) {
    for (const prereq of topic.prerequisites || []) edges.push({ from: prereq, to: topic.id, type: 'prerequisite' });
    for (const enabled of topic.conceptsEnabled || []) if (byId.has(enabled)) edges.push({ from: topic.id, to: enabled, type: 'enables' });
    for (const required of topic.conceptsRequired || []) if (byId.has(required)) edges.push({ from: required, to: topic.id, type: 'required-by' });
  }
  const unique = new Map();
  for (const edge of edges) unique.set(`${edge.from}->${edge.to}:${edge.type}`, edge);
  return Array.from(unique.values()).sort((a, b) => `${a.from}${a.to}${a.type}`.localeCompare(`${b.from}${b.to}${b.type}`));
}

function completeness(topic) {
  const present = REQUIRED_FIELDS.filter(field => field in topic && topic[field] !== '' && (!Array.isArray(topic[field]) || topic[field].length > 0 || OPTIONAL_EMPTY_ARRAY_FIELDS.has(field))).length;
  return Math.round((present / REQUIRED_FIELDS.length) * 100);
}

function pathFor(topics, mode) {
  const sorted = [...topics].sort((a, b) => a.semester - b.semester || a.difficulty.localeCompare(b.difficulty) || a.id.localeCompare(b.id));
  if (mode === 'exam') return sorted.sort((a, b) => (frequencyWeight[b.examFrequency] || 0) - (frequencyWeight[a.examFrequency] || 0) || a.semester - b.semester).map(t => t.id);
  if (mode === 'interview') return sorted.sort((a, b) => (frequencyWeight[b.interviewFrequency] || 0) - (frequencyWeight[a.interviewFrequency] || 0) || a.semester - b.semester).map(t => t.id);
  if (mode === 'industry') return sorted.sort((a, b) => b.industryUsage.length - a.industryUsage.length || a.semester - b.semester).map(t => t.id);
  return sorted.map(t => t.id);
}

function descendants(start, edges) {
  const next = new Map();
  for (const edge of edges) {
    if (!next.has(edge.from)) next.set(edge.from, []);
    next.get(edge.from).push(edge.to);
  }
  const seen = new Set();
  const queue = [...(next.get(start) || [])];
  while (queue.length) {
    const id = queue.shift();
    if (seen.has(id)) continue;
    seen.add(id);
    queue.push(...(next.get(id) || []));
  }
  return Array.from(seen).sort();
}

const topics = readJson(TOPICS_FILE);
const rawAssets = walk(ROOT).map(file => {
  const stat = fs.statSync(file);
  return {
    path: path.relative(ROOT, file).replaceAll(path.sep, '/'),
    type: classifyAsset(file),
    extension: path.extname(file).toLowerCase() || 'none',
    sizeBytes: stat.size,
    modifiedTime: stat.mtime.toISOString()
  };
}).sort((a, b) => a.path.localeCompare(b.path));
const assets = linkAssetsToTopics(rawAssets, topics);
const edges = buildEdges(topics);
const validation = validateTopics(topics);
const assetLinks = assets.flatMap(asset => asset.relatedTopics.map(topicId => ({ from: topicId, to: asset.path, type: 'documented-in' })));
const graph = {
  generatedAt: new Date().toISOString(),
  schemaVersion: '1.0.0',
  nodes: topics.map(topic => ({ ...topic, completenessScore: completeness(topic), downstreamConcepts: descendants(topic.id, edges) })),
  edges: [...edges, ...assetLinks],
  paths: {
    foundation: ['BCA-PF-001', 'BCA-DS-001', 'BCA-ALGO-001', 'BCA-OS-001', 'BCA-CN-001', 'BCA-DSYS-001'],
    learning: pathFor(topics, 'learning'),
    examRevision: pathFor(topics, 'exam'),
    interviewPreparation: pathFor(topics, 'interview'),
    industrySkill: pathFor(topics, 'industry')
  },
  searchIndex: topics.map(topic => ({ id: topic.id, title: topic.title, subject: topic.subject, semester: topic.semester, tags: topic.tags, keywords: topicKeywords(topic) }))
};
const orphanTopics = graph.nodes.filter(node => !graph.edges.some(edge => edge.from === node.id || edge.to === node.id)).map(node => node.id);
const duplicateAssets = assets.map(a => path.basename(a.path).toLowerCase()).filter((name, i, all) => all.indexOf(name) !== i);
const missingTopicDetector = REQUIRED_FIELDS.flatMap(field => validation.missingFields.map(item => item.field === field ? item : null).filter(Boolean));
const index = {
  generatedAt: graph.generatedAt,
  supportedSources: ['Markdown', 'PDFs', 'Images', 'Lab manuals', 'PPTs', 'External references', 'Code examples', 'Previous-year papers', 'University syllabus'],
  schema: REQUIRED_FIELDS,
  assets,
  topics: graph.nodes.map(node => ({ id: node.id, title: node.title, subject: node.subject, semester: node.semester, unit: node.unit, tags: node.tags, completenessScore: node.completenessScore }))
};
const report = {
  generatedAt: graph.generatedAt,
  totals: { topics: topics.length, assets: assets.length, graphEdges: graph.edges.length },
  prerequisiteValidator: validation.brokenPrerequisites,
  deadLinkDetector: assets.filter(asset => !fs.existsSync(path.join(ROOT, asset.path))).map(asset => asset.path),
  duplicateTopicDetector: validation.duplicateTopics,
  duplicateAssetDetector: Array.from(new Set(duplicateAssets)),
  missingTopicDetector,
  orphanTopics,
  averageCompletenessScore: Math.round(graph.nodes.reduce((sum, node) => sum + node.completenessScore, 0) / graph.nodes.length),
  successMetrics: {
    syllabusCoverageMode: 'seeded-canonical-topics-plus-repository-asset-index',
    everyTopicLinkedToPrerequisites: validation.brokenPrerequisites.length === 0,
    zeroOrphanTopics: orphanTopics.length === 0,
    automaticLearningPathsGenerated: Object.keys(graph.paths).length >= 4,
    graphExportReadyForAiApplications: true
  }
};
const visualization = {
  generatedAt: graph.generatedAt,
  nodes: graph.nodes.map(node => ({ id: node.id, label: node.title, group: node.subject, semester: node.semester, score: node.completenessScore })),
  links: graph.edges.filter(edge => !edge.to.includes('/')).map(edge => ({ source: edge.from, target: edge.to, type: edge.type }))
};
writeJson(INDEX_FILE, index);
writeJson(GRAPH_FILE, graph);
writeJson(VIS_FILE, visualization);
writeJson(REPORT_FILE, report);
console.log(`Generated ${path.basename(INDEX_FILE)}, ${path.basename(GRAPH_FILE)}, ${path.basename(VIS_FILE)}, and ${path.basename(REPORT_FILE)}.`);
console.log(`Topics: ${topics.length}; Assets: ${assets.length}; Edges: ${graph.edges.length}; Orphans: ${orphanTopics.length}.`);

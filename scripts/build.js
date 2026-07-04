const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const hljs = require('highlight.js');

// Configure marked with highlight.js
marked.setOptions({
    highlight: function (code, lang) {
        const language = hljs.getLanguage(lang) ? lang : 'plaintext';
        return hljs.highlight(code, { language }).value;
    },
    gfm: true,
    breaks: true
});

// HTML Template
const generateHTML = (content, title, relativeRoot) => `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    
    <!-- CSS Dependencies -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
    
    <!-- Shared Styles (copied from index.html) -->
    <style>
        :root {
            --bg-primary: #0a0a0a;
            --bg-secondary: #121212;
            --bg-tertiary: #1e1e1e;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --accent: #3b82f6;
            --accent-hover: #60a5fa;
            --border: #27272a;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
        }

        /* Reader Header */
        .reader-header {
            position: sticky;
            top: 0;
            background: rgba(10, 10, 10, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            z-index: 100;
        }

        .back-btn {
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
            color: var(--text-primary);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .back-btn:hover {
            background: #2a2a2a;
            transform: translateX(-2px);
        }

        /* Markdown Body */
        .markdown-body {
            max-width: 800px;
            margin: 0 auto;
            padding: 3rem 2rem 5rem 2rem;
            font-size: 1.1rem;
            color: #d1d5db;
        }

        .markdown-body h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            color: #ffffff;
            line-height: 1.2;
        }

        .markdown-body h2 {
            font-size: 1.8rem;
            font-weight: 600;
            margin-top: 3rem;
            margin-bottom: 1rem;
            color: #f3f4f6;
            border-bottom: 1px solid var(--border);
            padding-bottom: 0.5rem;
        }

        .markdown-body h3 {
            font-size: 1.4rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 0.75rem;
            color: #e5e7eb;
        }

        .markdown-body p {
            margin-bottom: 1.5rem;
        }

        .markdown-body ul, .markdown-body ol {
            margin-bottom: 1.5rem;
            padding-left: 1.5rem;
        }

        .markdown-body li {
            margin-bottom: 0.5rem;
        }

        .markdown-body a {
            color: var(--accent);
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: border-color 0.2s;
        }

        .markdown-body a:hover {
            border-bottom-color: var(--accent);
        }

        .markdown-body code {
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-tertiary);
            padding: 0.2em 0.4em;
            border-radius: 4px;
            font-size: 0.9em;
            color: #fca5a5;
        }

        .markdown-body pre {
            background: #0d1117;
            padding: 1.5rem;
            border-radius: 12px;
            overflow-x: auto;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border);
        }

        .markdown-body pre code {
            background: none;
            padding: 0;
            color: inherit;
            font-size: 0.95em;
        }

        .markdown-body blockquote {
            border-left: 4px solid var(--accent);
            padding-left: 1rem;
            margin-left: 0;
            color: var(--text-secondary);
            background: rgba(59, 130, 246, 0.05);
            padding: 1rem;
            border-radius: 0 8px 8px 0;
            margin-bottom: 1.5rem;
        }
        
        .markdown-body img {
            max-width: 100%;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .markdown-body hr {
            border: 0;
            height: 1px;
            background: var(--border);
            margin: 2rem 0;
        }
        
        @media (max-width: 768px) {
            .markdown-body {
                padding: 2rem 1.5rem;
            }
            .markdown-body h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="reader-header">
        <a href="${relativeRoot}index.html" class="back-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            Back to Hub
        </a>
        <div style="font-weight: 600; color: var(--text-secondary);">${title}</div>
    </div>
    
    <div class="markdown-body">
        ${content}
    </div>
</body>
</html>
`;

// Helper: Convert .md links to .html links inside the HTML content
function fixLinks(htmlContent) {
    // This regex looks for href="..." where it ends with .md or contains .md#
    // It captures the parts before and after .md to reconstruct it as .html
    return htmlContent.replace(/href=["']([^"']*\.md)(#[^"']*)?["']/g, (match, url, hash) => {
        // Don't replace if it's an external link
        if (url.startsWith('http')) return match;
        
        const newUrl = url.replace(/\.md$/, '.html');
        const hashPart = hash ? hash : '';
        return 'href="' + newUrl + hashPart + '"';
    });
}

function processDirectory(dir, rootDir) {
    const files = fs.readdirSync(dir);

    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            if (file !== 'node_modules' && file !== '.git') {
                processDirectory(fullPath, rootDir);
            }
        } else if (file.endsWith('.md')) {
            console.log('Processing: ' + fullPath);
            
            // Read Markdown
            const markdown = fs.readFileSync(fullPath, 'utf8');
            
            // Parse to HTML
            let html = marked.parse(markdown);
            
            // Fix internal .md links to point to .html
            html = fixLinks(html);
            
            // Determine relative root for the "Back to Hub" link
            const relativePath = path.relative(dir, rootDir);
            const relativeRoot = relativePath ? relativePath + '/' : './';
            
            // Title is the filename
            const title = file;
            
            // Generate final HTML wrapper
            const finalHTML = generateHTML(html, title, relativeRoot);
            
            // Save as .html
            const outPath = fullPath.replace(/\.md$/, '.html');
            fs.writeFileSync(outPath, finalHTML);
            console.log('Saved: ' + outPath);
        }
    }
}

const ROOT_DIR = path.resolve(__dirname, '..');
console.log('Starting build process in: ', ROOT_DIR);
processDirectory(ROOT_DIR, ROOT_DIR);
console.log('Build complete!');

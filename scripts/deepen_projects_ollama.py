import os
import glob
import time
import json
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configuration
PROJECTS_DIR = "/Users/dharamdaxini/projects/daxini-bca-learning/projects/"
REFERENCE_DIR = "/tmp/gym-reference/projects/02-multi-user/02-gym-management/"
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "zayvora:latest"

FILES_TO_PROCESS = [
    "ARCHITECTURE.md",
    "API_DESIGN.md",
    "COMMON_MISTAKES.md",
    "DEBUGGING_GUIDE.md",
    "LEARNING_PATH.md",
    "DATABASE.sql"
]

def load_reference(filename):
    path = os.path.join(REFERENCE_DIR, filename)
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            return f.read()
    return ""

def call_ollama(prompt):
    data = json.dumps({
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }).encode('utf-8')
    req = urllib.request.Request(OLLAMA_URL, data=data, headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=300) as response:
        result = json.loads(response.read().decode('utf-8'))
        return result.get('response', '')

def process_file(project_dir, filename):
    filepath = os.path.join(project_dir, filename)
    
    if not os.path.exists(filepath):
        return False
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    lines = content.split('\n')
    if len(lines) > 100:
        print(f"Skipping {os.path.basename(project_dir)}/{filename} (Already deep)")
        return False

    ref_content = load_reference(filename)
    project_name = os.path.basename(project_dir).replace('-', ' ').title()
    
    prompt = f"""
You are an expert software architecture instructor. 
We are creating project-based learning materials for BCA students.
The student is building: {project_name}

Here is the CURRENT (shallow) content for the '{filename}' file of this project:
---
{content}
---

Here is a REFERENCE example of what a high-quality, deep, detailed '{filename}' looks like (from a Gym Management project):
---
{ref_content}
---

YOUR TASK:
Rewrite the CURRENT content for {project_name} so that it matches the incredible depth, structure, and detail of the REFERENCE example.
- If it is ARCHITECTURE.md, include system diagrams and database relationship diagrams (using box-drawing characters).
- If it is DATABASE.sql, include a comprehensive schema with 5-7 tables, realistic columns, and foreign keys.
- If it is LEARNING_PATH.md, build a detailed multi-week or multi-step path.
- Expand significantly on the logic, edge cases, and "why" behind the designs.

Output ONLY the final rewritten content. Do NOT include markdown code block wrappers.
"""

    try:
        refined = call_ollama(prompt).strip()
        
        if refined.startswith("```markdown"):
            refined = refined[11:]
        elif refined.startswith("```sql"):
            refined = refined[6:]
        elif refined.startswith("```"):
            refined = refined[3:]
            
        if refined.endswith("```"):
            refined = refined[:-3]
            
        refined = refined.strip()
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(refined)
            
        print(f"✅ Deepened {os.path.basename(project_dir)}/{filename}")
        return True
    except Exception as e:
        print(f"❌ Error on {os.path.basename(project_dir)}/{filename}: {e}")
        return False

def process_project(project_dir):
    print(f"Processing project: {os.path.basename(project_dir)}")
    for filename in FILES_TO_PROCESS:
        process_file(project_dir, filename)

def main():
    projects = []
    for category in os.listdir(PROJECTS_DIR):
        cat_path = os.path.join(PROJECTS_DIR, category)
        if os.path.isdir(cat_path) and not category.startswith('.'):
            for proj in os.listdir(cat_path):
                proj_path = os.path.join(cat_path, proj)
                if os.path.isdir(proj_path) and os.path.exists(os.path.join(proj_path, "LEARNING_PATH.md")):
                    projects.append(proj_path)
    
    projects.sort()
    # Test on just the first 2 projects to verify it works, we don't want to lock the system for 4 hours yet
    test_projects = projects[:2]
    print(f"Found {len(projects)} projects total. Running test batch on {len(test_projects)} projects.")
    
    for p in test_projects:
        process_project(p)

if __name__ == "__main__":
    main()

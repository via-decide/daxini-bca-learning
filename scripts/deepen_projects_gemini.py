import os
import glob
import time
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import google.generativeai as genai

# Configuration
PROJECTS_DIR = "/Users/dharamdaxini/projects/daxini-bca-learning/projects/"
REFERENCE_DIR = "/tmp/gym-reference/projects/02-multi-user/02-gym-management/"

# Files to deepen
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

def process_file(project_dir, filename, model):
    filepath = os.path.join(project_dir, filename)
    
    # Check if it needs processing
    if not os.path.exists(filepath):
        return False
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    lines = content.split('\n')
    # If the file is already deep (e.g. > 120 lines), skip it to save tokens
    if len(lines) > 100:
        print(f"Skipping {os.path.basename(project_dir)}/{filename} (Already deep: {len(lines)} lines)")
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

Output ONLY the final rewritten content. Do NOT include markdown code block wrappers (like ```markdown) at the start/end unless it is DATABASE.sql which can be standard text.
"""

    try:
        response = model.generate_content(prompt)
        refined = response.text.strip()
        
        # Strip potential markdown wrappers
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

def process_project(project_dir, model):
    print(f"Processing project: {os.path.basename(project_dir)}")
    for filename in FILES_TO_PROCESS:
        process_file(project_dir, filename, model)
        time.sleep(2) # Safety sleep for rate limits

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--limit', type=int, default=0, help="Limit number of projects to process")
    args = parser.parse_args()

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable is not set.")
        print("Please run: export GEMINI_API_KEY='your_key'")
        return

    genai.configure(api_key=api_key)
    # Using flash as it is fast and capable enough for this transformation
    model = genai.GenerativeModel('gemini-2.5-flash')

    # Find all project directories
    projects = []
    for category in os.listdir(PROJECTS_DIR):
        cat_path = os.path.join(PROJECTS_DIR, category)
        if os.path.isdir(cat_path) and not category.startswith('.'):
            for proj in os.listdir(cat_path):
                proj_path = os.path.join(cat_path, proj)
                if os.path.isdir(proj_path) and os.path.exists(os.path.join(proj_path, "LEARNING_PATH.md")):
                    projects.append(proj_path)
    
    projects.sort()
    if args.limit > 0:
        projects = projects[:args.limit]
        
    print(f"Found {len(projects)} projects to deepen.")
    
    for p in projects:
        process_project(p, model)

if __name__ == "__main__":
    main()

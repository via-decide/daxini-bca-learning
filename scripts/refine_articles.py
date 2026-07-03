import os
import re
import glob
import time
import argparse
import google.generativeai as genai
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configuration
SOURCE_DIR = "/Users/dharamdaxini/Downloads/via/daxini.xyz/articles/"
DEST_DIR = "/Users/dharamdaxini/projects/daxini-bca-learning/docs/articles/"

PROMPT = """
You are an expert technical editor for an educational computer engineering repository.
I am providing you with the raw text of an article.
Please refine and format this article into clean, standard Markdown suitable for offline reading.

Instructions:
1. Improve readability, structure, and formatting.
2. If the article discusses architectural concepts, systems, workflows, data models, or processes, generate exactly ONE Mermaid.js diagram (`mermaid ... `) at the most appropriate location to visually explain it.
3. If no diagram is logically needed, do not force one.
4. Output ONLY the refined Markdown text. Do not include any meta-commentary or conversational filler.
5. Use proper Markdown headings (#, ##, ###).

Raw Article Text:
{text}
"""

def extract_text_from_html(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract Title (optional, but good to have)
    title_match = re.search(r'title:\s*{\s*en:\s*`([^`]+)`', content)
    title = title_match.group(1) if title_match else os.path.basename(filepath)

    # Extract all html blocks in the SECTIONS array
    html_blocks = re.findall(r'html:\s*{\s*en:\s*\(\)\s*=>\s*`([\s\S]*?)`', content)
    
    raw_text_parts = [f"# {title}\n"]
    for block in html_blocks:
        soup = BeautifulSoup(block, "html.parser")
        text = soup.get_text(separator='\n', strip=True)
        # Filter out UI elements like 'Subscribe to Dispatches', 'Share This Article'
        if "Subscribe to Dispatches" in text or "Share This Article" in text:
            continue
        raw_text_parts.append(text)
    
    return "\n\n".join(raw_text_parts)

def process_article(filepath, model):
    basename = os.path.basename(filepath)
    md_filename = basename.replace('.html', '.md')
    dest_path = os.path.join(DEST_DIR, md_filename)
    
    if os.path.exists(dest_path):
        print(f"Skipping {basename} (already exists)")
        return
        
    print(f"Extracting {basename}...")
    try:
        raw_text = extract_text_from_html(filepath)
        if len(raw_text.strip()) < 50:
            print(f"  -> {basename} has too little content, skipping.")
            return

        print(f"Sending {basename} to Gemini for refinement...")
        response = model.generate_content(PROMPT.format(text=raw_text))
        refined_md = response.text.strip()
        
        # Remove markdown code block wrappers if Gemini wrapped the whole response
        if refined_md.startswith("```markdown"):
            refined_md = refined_md[11:]
        if refined_md.startswith("```"):
            refined_md = refined_md[3:]
        if refined_md.endswith("```"):
            refined_md = refined_md[:-3]
            
        refined_md = refined_md.strip()

        with open(dest_path, 'w', encoding='utf-8') as f:
            f.write(refined_md)
            
        print(f"Successfully saved {md_filename}")
        time.sleep(2) # Rate limit safety
    except Exception as e:
        print(f"Error processing {basename}: {e}")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--limit', type=int, default=0, help="Limit number of articles to process")
    args = parser.parse_args()

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable is not set.")
        return

    genai.configure(api_key=api_key)
    # Using flash as it's fast and cheap for 126 articles
    model = genai.GenerativeModel('gemini-1.5-flash')

    files = glob.glob(os.path.join(SOURCE_DIR, "*.html"))
    print(f"Found {len(files)} articles.")
    
    if args.limit > 0:
        files = files[:args.limit]
        print(f"Limiting to {args.limit} articles.")

    for filepath in files:
        process_article(filepath, model)

if __name__ == "__main__":
    main()

import os
import re
import glob
from bs4 import BeautifulSoup

# Configuration
SOURCE_DIR = "/Users/dharamdaxini/Downloads/via/daxini.xyz/articles/"
DEST_DIR = "/Users/dharamdaxini/projects/daxini-bca-learning/docs/articles/"

def extract_text_from_html(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract Title
    title_match = re.search(r'title:\s*{\s*en:\s*`([^`]+)`', content)
    title = title_match.group(1) if title_match else os.path.basename(filepath).replace('.html', '').replace('-', ' ').title()

    # Extract all html blocks in the SECTIONS array
    html_blocks = re.findall(r'html:\s*{\s*en:\s*\(\)\s*=>\s*`([\s\S]*?)`', content)
    
    raw_text_parts = [f"# {title}\n"]
    for block in html_blocks:
        soup = BeautifulSoup(block, "html.parser")
        
        # Format blockquotes properly
        for bq in soup.find_all('blockquote'):
            bq.string = f"\n> {bq.get_text(strip=True)}\n"
            
        # Format code blocks
        for pre in soup.find_all('pre'):
            code = pre.find('code')
            code_text = code.get_text() if code else pre.get_text()
            pre.string = f"\n```\n{code_text}\n```\n"

        text = soup.get_text(separator='\n\n', strip=True)
        
        # Filter out UI elements
        if "Subscribe to Dispatches" in text or "Share This Article" in text:
            continue
            
        raw_text_parts.append(text)
    
    return "\n\n".join(raw_text_parts)

def process_all_articles():
    files = glob.glob(os.path.join(SOURCE_DIR, "*.html"))
    print(f"Found {len(files)} articles. Converting to Markdown...")
    
    count = 0
    for filepath in files:
        basename = os.path.basename(filepath)
        md_filename = basename.replace('.html', '.md')
        dest_path = os.path.join(DEST_DIR, md_filename)
        
        try:
            raw_text = extract_text_from_html(filepath)
            if len(raw_text.strip()) < 50:
                continue
                
            with open(dest_path, 'w', encoding='utf-8') as f:
                f.write(raw_text)
            count += 1
        except Exception as e:
            print(f"Failed to process {basename}: {e}")
            
    print(f"Successfully converted {count} articles to standard Markdown.")

if __name__ == "__main__":
    process_all_articles()

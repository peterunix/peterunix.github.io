import os
import yaml

content_path = "./content/posts/"

def publish_drafts():
    for root, dirs, files in os.walk(content_path):
        for file in files:
            if file.endswith(".org"):  # Assuming your posts are Markdown files
                file_path = os.path.join(root, file)
                with open(file_path, "r") as f:
                    content = f.read()
                    front_matter, content_body = content.split("---\n", 2)[1:]  # Split front matter from content
                    data = yaml.safe_load(front_matter)
                if "draft" in data and data["draft"] is True:
                    data["draft"] = False  # Set the draft parameter to false
                    new_front_matter = yaml.dump(data, default_flow_style=False)
                    new_content = f"---\n{new_front_matter}---\n{content_body}"
                    with open(file_path, "w") as f:
                        f.write(new_content)

if __name__ == "__main__":
    publish_drafts()

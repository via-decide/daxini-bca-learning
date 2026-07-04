-- Schema Design
CREATE TABLE recipes (
    id UUID PRIMARY KEY,
    author_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    instructions JSONB NOT NULL, -- Storing steps as an array of strings
    prep_time_mins INT
);

CREATE TABLE tags (
    id UUID PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE recipe_tags (
    recipe_id UUID REFERENCES recipes(id),
    tag_id UUID REFERENCES tags(id),
    PRIMARY KEY (recipe_id, tag_id)
);

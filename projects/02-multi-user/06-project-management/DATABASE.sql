-- Schema Design
CREATE TABLE projects (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    owner_id UUID REFERENCES users(id)
);

CREATE TABLE tasks (
    id UUID PRIMARY KEY,
    project_id UUID REFERENCES projects(id),
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'backlog'
);

CREATE TABLE task_dependencies (
    blocking_task_id UUID REFERENCES tasks(id),
    blocked_task_id UUID REFERENCES tasks(id),
    PRIMARY KEY (blocking_task_id, blocked_task_id)
);

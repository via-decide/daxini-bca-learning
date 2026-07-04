-- Schema Design
CREATE TABLE books (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    total_copies INT DEFAULT 1
);

CREATE TABLE borrowing_records (
    id UUID PRIMARY KEY,
    book_id UUID REFERENCES books(id),
    user_id UUID REFERENCES users(id),
    borrow_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0.00
);

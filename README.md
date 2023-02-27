# Project Title: Create_Trigger_seq
## Overview
This PL/SQL project is designed to create new sequences and triggers for Oracle databases. It addresses the problem of managing primary key values across multiple tables, by automatically creating unique sequences and triggers for each table that has a primary key ending in "_ID". Our proposed solution is to use a cursor to identify the relevant tables and columns, drop any existing sequences, and create new sequences and triggers with starting values based on the current maximum value in the primary key column. The main goal of the project is to simplify database management and ensure data integrity.

## Usage
To use this project, simply run the "Create_Trigger_seq" procedure in your SQL developer console. Here's an example of how to use it:

-- First, create the procedure
CREATE OR REPLACE PROCEDURE Create_Trigger_seq
AS
   -- Insert PL/SQL code here
END;

-- Then, execute the procedure
BEGIN
   Create_Trigger_seq;
END;

- The procedure will automatically drop any existing sequences and create new ones for each table with a primary key ending in "_ID". It will also create new triggers to ensure that the sequence values are used as the primary key values for new records.

## Tools and Technologies:
- PLSQL.
- Sequences.
- Triggers.
- TOAD.

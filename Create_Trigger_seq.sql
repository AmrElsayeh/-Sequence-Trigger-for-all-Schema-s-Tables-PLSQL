/*
Formatted on 04/01/2023 16:31:44 (QP5 v5.139.911.3011)
Stored procedure named "Create_Trigger_seq" that creates a new sequence and trigger for each table in the database that has a primary key column named with a specific pattern.
*/
CREATE OR REPLACE PROCEDURE Create_Trigger_seq
AS
/* Declare a cursor named "seq_cursor" that selects all sequences owned by the current user that have a name ending with "_SEQ" */
   CURSOR seq_cursor
   IS
      SELECT *
        FROM user_sequences
       WHERE sequence_name LIKE '%_SEQ';
/* Declare a cursor named "pk_cur" that selects all primary key columns in tables owned by 
the current user that have names containing the string "ID" and that are not in the tables 
"countries", "jobs", or "job_history". */
   CURSOR pk_cur
   IS
      SELECT *
        FROM user_cons_columns
       WHERE     constraint_name LIKE '%PK%'
             AND column_name LIKE '%ID'
             AND LOWER (table_name) NOT IN ('countries', 'jobs','job_history');
/* Declare two variables to store the maximum value of the primary key column and a
 number to increment the sequence by. */
   p_max   NUMBER (6);
   p_num   NUMBER (3);
BEGIN
/* Loop through each sequence selected by the "seq_cursor" and drop it using dynamic 
SQL. */
   FOR seq IN seq_cursor
   LOOP
      EXECUTE IMMEDIATE 'drop sequence ' || seq.sequence_name;
   END LOOP;
/* Loop through each primary key column selected by the "pk_cur" cursor. For each primary key column:
- Select the maximum value of that column from the corresponding table and add one to it to determine the starting value for the new sequence.
- Create a new sequence using dynamic SQL with a name that matches the pattern "table_name_SEQ" and the starting value determined earlier.
- Create a new trigger using dynamic SQL for the corresponding table. The trigger assigns the next value from the new sequence to the primary key column of the inserted row. */

   FOR pk_rec IN pk_cur
   LOOP
      EXECUTE IMMEDIATE   'select max('
                       || pk_rec.COLUMN_NAME
                       || ')  from '
                       || pk_rec.TABLE_NAME
         INTO p_max;

      p_max := p_max + 1;

      EXECUTE IMMEDIATE   'create sequence '
                       || pk_rec.table_name
                       || '_seq'
                       || ' start with '
                       || p_max
                       || ' increment by 10 nocache nocycle';

      EXECUTE IMMEDIATE   'CREATE OR REPLACE TRIGGER '
                       || pk_rec.TABLE_NAME
                       || '_TRG'
                       || ' BEFORE INSERT ON '
                       || pk_rec.TABLE_NAME
                       || ' REFERENCING NEW AS New OLD AS Old FOR EACH ROW BEGIN :new.'
                       || pk_rec.COLUMN_NAME
                       || ' := '
                       || pk_rec.TABLE_NAME
                       || '_seq.NEXTVAL; END;';
   END LOOP;
END;

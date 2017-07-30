DEFINE src_schema=&1
DEFINE dest_schema=&2

SET SERVEROUTPUT ON
SET DEFINE ON

DECLARE
    v_cursor   SYS_REFCURSOR;
    v_c1       dba_objects%ROWTYPE;
    v_sql      VARCHAR2 (2000);
BEGIN
    OPEN v_cursor FOR
        SELECT *
          FROM dba_objects
         WHERE object_type = 'PACKAGE' AND owner = '&src_schema';

    LOOP
        FETCH v_cursor   INTO v_c1;

        EXIT WHEN v_cursor%NOTFOUND;

        IF v_cursor%ISOPEN THEN
            v_sql :=
                   'CREATE OR REPLACE SYNONYM &dest_schema..'
                || v_c1.object_name
                || ' for &src_schema..'
                || v_c1.object_name;
               -- || ';';

            EXECUTE IMMEDIATE v_sql;
            dbms_output.put_line(v_sql);
        END IF;
    END LOOP;

    IF v_cursor%ISOPEN THEN
        CLOSE v_cursor;
    END IF;
END;
/

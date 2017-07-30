SET HEADING OFF;
SET FEEDBACK OFF;
SET ESCAPE OFF;
SET ECHO OFF;
SET LINES 999;
SET SERVEROUTPUT ON;
SET WRAP OFF;

BEGIN
for cur_rec IN (SELECT object_name, object_type FROM user_objects WHERE status <> 'VALID' ORDER BY 1)
LOOP
	BEGIN
		IF cur_rec.object_type = 'PACKAGE BODY' THEN
			EXECUTE IMMEDIATE 'ALTER PACKAGE "' || cur_rec.object_name || '" COMPILE BODY';
		ELSE
			EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" COMPILE';
		END IF;
END;
	END LOOP;
END;
/


EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('EXCEPTION ON OBJECT:' || cur_rec.object_type ||  ' : ' || cur_rec.object_name);
		

ELSEIF cur_rec.object_type='SYNONYM' THEN
			EXECUTE IMMEDIATE 'ALTER SYNONYM "' || cur_rec.object_name || '" COMPILE';

DECLARE 
v_compile VARCHAR2(200);
v_compile_body VARCHAR2(200);
BEGIN
v_compile := 'SELECT ''ALTER '' || object_type || '' '' || object_name || '' COMPILE;'' FROM  user_objects WHERE status = ''INVALID'' AND object_type IN (''PACKAGE'',''PROCEDURE'',''FUNCTION'',''TRIGGER'',''VIEW'')';
v_compile_body := 'SELECT ''ALTER PACKAGE '' || object_name || '' '' || '' COMPILE BODY;'' FROM user_objects WHERE status = ''INVALID'' AND object_type IN (''PACKAGE BODY'')';
EXECUTE IMMEDIATE v_compile;
EXECUTE IMMEDIATE v_compile_body;
END;
/

SET LINESIZE 32000
SET PAGESIZE 0
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
set termout off
SET VERIFY OFF

DEFINE schema_name=&1
DEFINE package_name=&2

SPOOL &schema_name..&package_name..Head.sql

select text from dba_source where name='&package_name' and type='PACKAGE' and owner='&schema_name' order by line;

SPOOL OFF;

SPOOL &schema_name..&package_name..Body.sql

select text from dba_source where name='&package_name' and type='PACKAGE BODY' and owner='&schema_name' order by line;

SPOOL OFF;
exit;

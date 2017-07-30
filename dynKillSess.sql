/* Generates kill session statements for Oracle for blocking sessions */

SELECT 'ALTER SYSTEM KILL SESSION '||Chr(39)||sess.sid||','||sess.serial#|| ',' || '@' ||sess.blocking_instance||Chr(39)||' IMMEDIATE;' AS CMDs
from    gv$session sess
where   sess.username is not null
and     sess.blocking_session is not null
and     sess.wait_time = 0
and     sess.seconds_in_wait > 1800;

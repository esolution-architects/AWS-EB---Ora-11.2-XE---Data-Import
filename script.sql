create tablespace &3 datafile size 1G autoextend on maxsize unlimited;
create user &1 identified by &2;
grant DBA to &1;

quit;
/
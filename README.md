# AWS Elastic Beanstalk - Oracle 11.2 XE - Data Import

This will deploy an Oracle 11.2 XE databse and run SQL commands. Intended to import data into a database with Oracle's exp/imp commands.


## Instructions:
1) Get the dump file from the source database using the 11.2 exp utility provided by Oracle
2) Downoad this source, customize it to fit your needs. Zip it up.
3) Create an S3 bucket and upload your data dump file and [ 
Oracle Database Express Edition 11g Release 2 for Linux x64](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) file.
  - The files should be uploaded to this location: s3://< S3 Bucket Name >/oracle/< files >
  - The data dump file should have a '.dmp' file extension.
  - Make note the size of the uncompressed dump file 
4) Create an empty Oracle RDS instance. Make note the host name, sid, port, root username, root password. 
5) Create an Elastic Beanstalk Application 
  - Env Type: WebServer
  - Platform: Generic Docker
  - Autoscaling: Single Instance
  - Source Bundle: Zipped file of this Repo
  - Instance Type: t2.small
  - Root volume type: General Purpose SSD 
  - Root volume size: 20 gigs + the size of your dump file (uncompressed)
  - Env Variables:
    - HOST: < Host name of the Destination Database >
    - SID: < SID of the Destination Database >
    - PORT: < Port of the Destination Database >
    - USER_NAME_ROOT: < Root username of the Destination Database >
    - PASSWORD_ROOT: < Root password of the Destination Database >
    - USER_NAME: < Username of the user to create in the Destination Database >
    - PASSWORD: < Password of the user to create in the Destination Database >
    - TABLESPACE: < Tablespace name to create in the Destination Database >
    - SETUP_BUCKET: < Name of the S3 bucket created >
    - DUMP_FILE: < Name of the dump file uploaded to the S3 bucket, i.e. data_dump.dmp >
    - REFRESH: < Set to 'true' if you're refreshing the data. Set to 'false' if you're importing the data in the database for this first time >

  Note: If the REFRESH variable is set to true, this source will drop the user and tablespace, before creating a new user and tablespace. Otherwise, this will just create a new user and tablespace, without attempting to drop the user/tablespace.

  After launching the Environment, it will build your environment and perform the data import. The Environemnt will remain in grey status until the import is complete. Once completed, download the full logs and verify the import was successful (usually found in eb-activity.log and eb-docker/containers/eb-current-app/< container-id >-stdouterr.log). If the import was successful, terminate the environment and delete the application.




This source pulled and edited from [Oracle's Docker Images](https://github.com/oracle/docker-images/tree/master/OracleDatabase/dockerfiles/11.2.0.2)



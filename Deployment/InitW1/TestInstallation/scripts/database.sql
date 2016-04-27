--Start Writing Table ddls
DROP TABLE MYCLASS;

CREATE TABLE MYCLASS
(
	MY_ID NUMERIC(9,0)  NOT NULL  ,
	MY_NAME CHARACTER VARYING(256)  , 
	MYDOCFILEDATA BYTEA  , 
	MYDOCFILENAME CHARACTER VARYING(256)  , 
	MYDOCTWOFILEDATA BYTEA  , 
	MYDOCTWOFILENAME CHARACTER VARYING(256) ,
	MyClassVer NUMERIC (4, 0)  NOT NULL ,
	dmLastUpdateDate	TIMESTAMP WITH TIME ZONE	NOT NULL ,
	PRIMARY KEY ( 
	MY_ID  )
);
DROP TABLE MYCLASSEJB;

CREATE TABLE MYCLASSEJB
(
	MYID NUMERIC(9,0)  NOT NULL  ,
	MYNAME CHARACTER VARYING(256) ,
	MyClassEJBVer NUMERIC (4, 0)  NOT NULL ,
	dmLastUpdateDate	TIMESTAMP WITH TIME ZONE	NOT NULL ,
	PRIMARY KEY ( 
	MYID  )
);
--End Writing Table ddls
--Start Writing Index ddls
--End Writing Index ddls
--Start Writing Keys ddls
--End Writing Keys ddls
--Start Writing Sequence ddls
--End Writing Sequence ddls

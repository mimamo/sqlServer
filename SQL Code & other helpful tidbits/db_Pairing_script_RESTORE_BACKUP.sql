-- Stop KB Auditing Triggers
USE [DEN_DEV_SYS]
GO
DISABLE TRIGGER dbo.xADomain_Update ON dbo.Domain
GO
DISABLE TRIGGER dbo.xACompany_Update ON dbo.Company
GO
DISABLE TRIGGER dbo.xADomain_Insert ON dbo.Domain
GO
DISABLE TRIGGER dbo.xACompany_Insert ON dbo.Company
GO
DISABLE TRIGGER dbo.xADomain_Delete ON dbo.Domain
GO
DISABLE TRIGGER dbo.xACompany_Delete ON dbo.Company
GO
DISABLE TRIGGER dbo.xAAccessRights_Delete ON dbo.AccessRights
GO
DISABLE TRIGGER dbo.xAAccessRights_Insert ON dbo.AccessRights
GO
DISABLE TRIGGER dbo.xAAccessRights_Update ON dbo.AccessRights
GO
DISABLE TRIGGER dbo.xARptControl_Delete ON dbo.rptcontrol
GO
DISABLE TRIGGER dbo.xARptControl_Insert ON dbo.rptcontrol
GO
DISABLE TRIGGER dbo.xARptControl_Update ON dbo.rptcontrol
GO
DISABLE TRIGGER dbo.xAScreen_Delete ON dbo.Screen
GO
DISABLE TRIGGER dbo.xAScreen_Insert ON dbo.Screen
GO
DISABLE TRIGGER dbo.xAScreen_Update ON dbo.Screen
GO
DISABLE TRIGGER dbo.xAUserGrp_Delete ON dbo.UserGrp
GO
DISABLE TRIGGER dbo.xAUserGrp_Insert ON dbo.UserGrp
GO
DISABLE TRIGGER dbo.xAUserGrp_Update ON dbo.UserGrp
GO
DISABLE TRIGGER dbo.xAUserRec_Delete ON dbo.UserRec
GO
DISABLE TRIGGER dbo.xAUserRec_Insert ON dbo.UserRec
GO
-- get errors with these
DISABLE TRIGGER dbo.xASubXref_Delete ON dbo.SubXref
GO
DISABLE TRIGGER dbo.xASubXref_Insert ON dbo.SubXref
GO
DISABLE TRIGGER dbo.xASubXref_Update ON dbo.SubXref
GO
DISABLE TRIGGER dbo.xAUserRec_Update ON dbo.UserRec
GO

--- Probably do not need this any more
/*
SELECT *
FROM sys.triggers
WHERE [name] like 'xA%'

--*************************************************************************************************************************************
--*************************************************************************************************************************************
--*********************************************KBAudit Maintenance APP db**************************************************************
ALTER View [dbo].[xvs_xASetupLog] (AID, ASolomonUserID, ADate, ATime, AProcess, DB, Module, TableName, TableDescr, tstamp)
AS
Select a.AID, a.ASolomonUserID, a.ADate, a.ATime, a.AProcess, CONVERT(Char(3), 'App') AS DB, a.Module, a.TableName, b.TableDescr, a.tstamp From xASetupLog a Left Join xATABLES b On a.TableName = b.TableName
Union All
Select a.AID, a.ASolomonUserID, a.ADate, a.ATime, a.AProcess, CONVERT(Char(3), 'Sys') AS DB, a.Module, a.TableName, b.TableDescr, a.tstamp From STAGEDENVERSYS.dbo.xASetupLog a Left Join STAGEDENVERSYS.dbo.xATABLES b On a.TableName = b.TableName
GO

ALTER View [dbo].[xvs_xATABLES] (Module, TableDescr, TableName, AddTable, RemoveTable, AuditTable, InitialData, IndexName, tstamp)ASSelect  *  From xATABLESUnion AllSelect  *  From STAGEDENVERSYS.dbo.xATABLES
GO
--*************************************************************************************************************************************
--*************************************************************************************************************************************


--************************************************************************************************************************************
--************************************************************************************************************************************
--*********************************************Orphaned Maintenance*******************************************************************
exec sp_change_users_login 'Report'
GO
sp_change_users_login @Action='update_one', @UserNamePattern='ExclusionApp', 
   @LoginName='ExclusionApp';
GO
--*************************************************************************************************************************************
--*************************************************************************************************************************************
*/
--SYS db Name here
USE [DEN_DEV_SYS] 

SELECT *
FROM Company

SELECT *
FROM Domain

-- may not need any longer
/*
DELETE FROM Company
WHERE CpnyID in ('SP2')
-- again might not need
DELETE FROM Domain
WHERE DatabaseName in ('SP2APP')
*/


UPDATE Company
SET DatabaseName = 'DEN_DEV_APP'
WHERE DatabaseName = 'DENVERAPP'

UPDATE Domain
SET DatabaseName = 'DEN_DEV_APP'
WHERE DatabaseName = 'DENVERAPP'

UPDATE Company
SET DatabaseName = 'MID_DEV_APP'
WHERE DatabaseName = 'MIDWESTAPP'

UPDATE Domain
SET DatabaseName = 'MID_DEV_APP'
WHERE DatabaseName = 'MIDWESTAPP'

UPDATE Company
SET DatabaseName = 'NYC_DEV_APP'
WHERE DatabaseName = 'NEWYORKAPP'

UPDATE Domain
SET DatabaseName = 'NYC_DEV_APP'
WHERE DatabaseName = 'NEWYORKAPP'

delete from Company where DatabaseName = 'STREETSOURCEAPP'
delete from domain where DatabaseName = 'STREETSOURCEAPP'

-- may not need any longer
/*
UPDATE Company
SET DatabaseName = 'STAGESSAPP'
WHERE DatabaseName = 'STREETSOURCEAPP'
-- No longer aplicable
UPDATE Domain
SET DatabaseName = 'STAGESSAPP'
WHERE DatabaseName = 'STREETSOURCEAPP'
*/

-- Update the system database
UPDATE Domain
SET DatabaseName = 'DEN_DEV_SYS'
WHERE DatabaseName = 'DENVERSYS'

-- change the sql server
UPDATE Domain
SET ServerName = 'SQLDEV2'
WHERE ServerName = 'SQL1'

SELECT *
FROM Company

SELECT *
FROM Domain

--Run db Maintenance

/*
--Probably is no loger needed
UPDATE Company
SET CpnyName = 'STAGE SS db-DO NOT USE'
WHERE CpnyID = 'SS'

UPDATE Company
SET CpnyName = 'STAGE DENVER db-DO NOT USE'
WHERE CpnyID = 'DENVER'
*/


-- Restart KB Auditing Triggers
ENABLE TRIGGER dbo.xADomain_Update ON dbo.Domain
GO
ENABLE TRIGGER dbo.xACompany_Update ON dbo.Company
GO
ENABLE TRIGGER dbo.xADomain_Insert ON dbo.Domain
GO
ENABLE TRIGGER dbo.xACompany_Insert ON dbo.Company
GO
ENABLE TRIGGER dbo.xADomain_Delete ON dbo.Domain
GO
ENABLE TRIGGER dbo.xACompany_Delete ON dbo.Company
GO
ENABLE TRIGGER dbo.xAAccessRights_Delete ON dbo.AccessRights
GO
ENABLE TRIGGER dbo.xAAccessRights_Insert ON dbo.AccessRights
GO
ENABLE TRIGGER dbo.xAAccessRights_Update ON dbo.AccessRights
GO
ENABLE TRIGGER dbo.xARptControl_Delete ON dbo.rptcontrol
GO
ENABLE TRIGGER dbo.xARptControl_Insert ON dbo.rptcontrol
GO
ENABLE TRIGGER dbo.xARptControl_Update ON dbo.rptcontrol
GO
ENABLE TRIGGER dbo.xAScreen_Delete ON dbo.Screen
GO
ENABLE TRIGGER dbo.xAScreen_Insert ON dbo.Screen
GO
ENABLE TRIGGER dbo.xAScreen_Update ON dbo.Screen
GO
ENABLE TRIGGER dbo.xASubXref_Delete ON dbo.SubXref
GO
ENABLE TRIGGER dbo.xASubXref_Insert ON dbo.SubXref
GO
ENABLE TRIGGER dbo.xASubXref_Update ON dbo.SubXref
GO
ENABLE TRIGGER dbo.xAUserGrp_Delete ON dbo.UserGrp
GO
ENABLE TRIGGER dbo.xAUserGrp_Insert ON dbo.UserGrp
GO
ENABLE TRIGGER dbo.xAUserGrp_Update ON dbo.UserGrp
GO
ENABLE TRIGGER dbo.xAUserRec_Delete ON dbo.UserRec
GO
ENABLE TRIGGER dbo.xAUserRec_Insert ON dbo.UserRec
GO
ENABLE TRIGGER dbo.xAUserRec_Update ON dbo.UserRec
GO


-- Probably do not need
/*
Delete from Roidetail
Delete from Rptcompany
Delete from Rptruntime

DELETE FROM Rptextra


INSERT INTO Company ([Active],[Addr1],[Addr2],[BaseCuryID],[City],[Country],[CpnyID],[CpnyCOA],[CpnySub],[CpnyName],[DatabaseName],[Fax],[IASEmailAddress],[IASPubKey],[IASPubKeySize]
,[IASRemoteAccess],[InterCpnyID],[LocalDomain],[Master_Fed_ID],[Phone],[State],[User1],[User2],[User3],[User4],[Zip])
SELECT [Active],[Addr1],[Addr2],[BaseCuryID],[City],[Country],[CpnyID],[CpnyCOA],[CpnySub],[CpnyName],'zzSTREETSOURCEAPP',[Fax],[IASEmailAddress],[IASPubKey],[IASPubKeySize]
,[IASRemoteAccess],[InterCpnyID],[LocalDomain],[Master_Fed_ID],[Phone],[State],[User1],[User2],[User3],[User4],[Zip]
FROM SQL1.DENVERSYS.dbo.Company
WHERE DatabaseName = 'STREETSOURCEAPP'


INSERT INTO Domain (CurrentPassword, DatabaseName, Description, LocalDB, RecordType, RemoteAccess, ServerName,
User1, User2, User3, User4)
SELECT CurrentPassword, 'zzSTREESOURCEAPP', Description, LocalDB, RecordType, RemoteAccess, ServerName,
User1, User2, User3, User4
FROM SQL1.DENVERSYS.dbo.Domain
WHERE DatabaseName = 'STREETSOURCEAPP'


UPDATE Domain
SET DatabaseName = 'zzSTREETSOURCEAPP'
WHERE DatabaseName = 'zzSTREESOURCEAPP'

DROP TABLE Domain

SELECT *
INTO Domain
FROM CRAPSYS..Domain
*/
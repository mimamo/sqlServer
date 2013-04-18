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
/*
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
GO

SELECT *
FROM Company

SELECT *
FROM Domain


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

UPDATE Company
SET DatabaseName = 'LA_DEV_APP'
WHERE DatabaseName = 'LAAPP'

UPDATE Domain
SET DatabaseName = 'LA_DEV_APP'
WHERE DatabaseName = 'LAAPP'

delete from Company where DatabaseName = 'STREETSOURCEAPP'
delete from domain where DatabaseName = 'STREETSOURCEAPP'
                                    

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


----- ***********   REMEMBER TO UPDATE THE VIEWS AND SYNC SECURITY AND OWNERSHIP IN DYNAMICS DATABASE MAINT.   *********** -----
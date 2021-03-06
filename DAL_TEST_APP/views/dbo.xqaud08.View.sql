USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqaud08]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqaud08]

as

SELECT RI_ID, 'AccessRights' As AuditTableName, am.ASLUserID, am.ADate, cPost.RecType + cPost.UserId + cPost.CompanyID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'CompanyID' as Field, replace(cPre.CompanyID,'''','') as PreValue, replace(cPost.CompanyID,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAAccessRights cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAAccessRights cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'AccessRights' AND ((isnull(cPre.CompanyID,'') <> isnull(cPost.CompanyID,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'AccessRights' As AuditTableName, am.ASLUserID, am.ADate, cPost.RecType + cPost.UserId + cPost.CompanyID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'DatabaseName' as Field, replace(cPre.DatabaseName,'''','') as PreValue, replace(cPost.DatabaseName,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAAccessRights cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAAccessRights cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'AccessRights' AND ((isnull(cPre.DatabaseName,'') <> isnull(cPost.DatabaseName,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'AccessRights' As AuditTableName, am.ASLUserID, am.ADate, cPost.RecType + cPost.UserId + cPost.CompanyID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'RecType' as Field, replace(cPre.RecType,'''','') as PreValue, replace(cPost.RecType,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAAccessRights cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAAccessRights cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'AccessRights' AND ((isnull(cPre.RecType,'') <> isnull(cPost.RecType,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'AccessRights' As AuditTableName, am.ASLUserID, am.ADate, cPost.RecType + cPost.UserId + cPost.CompanyID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'UserId' as Field, replace(cPre.UserId,'''','') as PreValue, replace(cPost.UserId,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAAccessRights cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAAccessRights cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'AccessRights' AND ((isnull(cPre.UserId,'') <> isnull(cPost.UserId,'')) or am.AProcess = 'I')
GO

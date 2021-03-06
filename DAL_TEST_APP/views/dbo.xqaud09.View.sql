USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqaud09]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqaud09]

as

SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'GroupId' as Field, replace(cPre.GroupId,'''','') as PreValue, replace(cPost.GroupId,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.GroupId,'') <> isnull(cPost.GroupId,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'User1' as Field, replace(cPre.User1,'''','') as PreValue, replace(cPost.User1,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.User1,'') <> isnull(cPost.User1,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'User2' as Field, replace(cPre.User2,'''','') as PreValue, replace(cPost.User2,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.User2,'') <> isnull(cPost.User2,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'User3' as Field, replace(cPre.User3,'''','') as PreValue, replace(cPost.User3,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.User3,'') <> isnull(cPost.User3,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'User4' as Field, replace(cPre.User4,'''','') as PreValue, replace(cPost.User4,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.User4,'') <> isnull(cPost.User4,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'UserGrp' As AuditTableName, am.ASLUserID, am.ADate, cPost.GroupID + cPost.UserId as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'UserId' as Field, replace(cPre.UserId,'''','') as PreValue, replace(cPost.UserId,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN DallasSystem.dbo.xAUserGrp cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN DallasSystem.dbo.xAUserGrp cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'UserGrp' AND ((isnull(cPre.UserId,'') <> isnull(cPost.UserId,'')) or am.AProcess = 'I')
GO

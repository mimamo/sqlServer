USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xqaud06]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqaud06]

as

SELECT RI_ID, 'VENDOR' As AuditTableName, am.ASLUserID, am.ADate, cPost.VendID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'VendId' as Field, replace(cPre.VendId,'''','') as PreValue, replace(cPost.VendId,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN xAVENDOR cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN xAVENDOR cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'VENDOR' AND ((isnull(cPre.VendId,'') <> isnull(cPost.VendId,'')) or am.AProcess = 'I') UNION ALL
SELECT RI_ID, 'VENDOR' As AuditTableName, am.ASLUserID, am.ADate, cPost.VendID as KeyValue, am.PreAID, am.PostAID, am.AProcess, 'Zip' as Field, replace(cPre.Zip,'''','') as PreValue, replace(cPost.Zip,'''','') as PostValue FROM xqaauditmaster am LEFT JOIN xAVENDOR cPost on am.PostAID = cPost.AID AND am.AProcess <> 'D' LEFT JOIN xAVENDOR cPre on am.PreAID = cPre.AID WHERE AuditTableName = 'VENDOR' AND ((isnull(cPre.Zip,'') <> isnull(cPost.Zip,'')) or am.AProcess = 'I') 

UNION ALL

SELECT RI_ID, AuditTableName, ASLUserID, ADate, KeyValue, PreAID, PostAID, AProcess, Field, PreValue, PostValue FROM xqaud06ex
GO

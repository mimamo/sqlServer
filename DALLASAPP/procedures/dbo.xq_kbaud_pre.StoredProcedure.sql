USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xq_kbaud_pre]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xq_kbaud_pre] (@RI_ID int)

as

set nocount on

Declare @startdate char(80), @enddate char(80)

-- get start and end date paramters
select @startdate = convert(varchar(10),ltrim(rtrim(longanswer00)),101),
       @enddate = convert(varchar(10),ltrim(rtrim(longanswer01)),101)
from rptruntime
where ri_id = @RI_ID
 
-- clear out existing records 
delete xqAAuditMaster where ri_id = @RI_ID

-- insert records
Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'Customer' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xACustomer pre WHERE pre.custid = post.custid and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xACustomer Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'Customer'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate


Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'Vendor' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xAVendor pre WHERE pre.vendid = post.vendid and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xAVendor Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'Vendor'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'PJPROJ' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xAPJPROJ pre WHERE pre.project = post.project and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xAPJPROJ Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'PJPROJ'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'PJEMPLOY' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xAPJEMPLOY pre WHERE pre.employee = post.employee and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xAPJEMPLOY Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'PJEMPLOY'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate


Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'LEDGER' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xALEDGER pre WHERE pre.ledgerid = post.ledgerid and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xALEDGER Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'LEDGER'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'PJPENT' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM xAPJPENT pre WHERE pre.project = post.project and pre.pjt_entity = post.pjt_entity and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM xAPJPENT Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'PJPENT'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'AccessDetRights' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM DallasSystem.dbo.xAAccessDetRights pre WHERE pre.RecType = post.RecType and pre.UserId = post.UserId and pre.CompanyID = post.CompanyID and pre.ScreenNumber = post.ScreenNumber and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM DallasSystem.dbo.xAAccessDetRights Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'AccessDetRights'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'AccessRights' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM DallasSystem.dbo.xAAccessRights pre WHERE pre.RecType = post.RecType and pre.UserId = post.UserId and pre.CompanyID = post.CompanyID and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM DallasSystem.dbo.xAAccessRights Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'AccessRights'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'UserGrp' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM DallasSystem.dbo.xAUserGrp pre WHERE pre.GroupID = post.GroupID and pre.UserId = post.UserId and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM DallasSystem.dbo.xAUserGrp Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'UserGrp'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate


Insert Into xqAAuditMaster
(RI_ID, AuditTableName, PostAID, PreAID, ASLUserID, ASQLUserID, AComputerName, ADate, ATime, AProcess, AApplication)

SELECT @RI_ID, 'UserRec' as AuditTableName, Post.AID AS PostAID, 
IsNull((SELECT MAX(AID) FROM DallasSystem.dbo.xAUserRec pre WHERE pre.RecType = post.RecType and pre.UserId = post.UserId and pre.AID < Post.AID),0) AS PreAID,
post.ASolomonUserID as ASLUserID, post.ASQLUserID, post.AComputerName, post.ADate, post.ATime, post.AProcess, post.AApplication
FROM DallasSystem.dbo.xAUserRec Post
Where Post.AID > IsNull((Select Max(PostAID) from xqAAuditMaster where RI_ID = @RI_ID and AuditTableName = 'UserRec'),0)
And convert(varchar(10),post.adate,101) between @startdate and @enddate

set nocount off
GO

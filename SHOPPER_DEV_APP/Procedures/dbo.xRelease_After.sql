USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xRelease_After]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xRelease_After]
 @batnbr varchar(10),
 @userid varchar (10)
as 

update 
	Batch 
SET 
	Batch.LUpd_DateTime = getdate(),
	Batch.LUpd_Prog = 'PARPT',
	Batch.LUpd_User = @userId,
	Batch.Status = 'U'
where
	module = 'PA' and 
	batnbr = @batnbr
GO

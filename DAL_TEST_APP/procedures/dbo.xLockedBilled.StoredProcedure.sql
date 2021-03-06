USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xLockedBilled]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xLockedBilled] 
@parm1 Varchar(1),
@parm2 varchar(16)
as

If @parm1 = 'A' --Toggle Amount
	Begin
	select sum(act_amount) from PJPTDSum  where
	PJPTDSum.Project = @parm2 and
	acct = 'Billed To Date'
	end
else
	Begin --Toggle Units
	select sum(act_Units) from PJPTDSum  where
	PJPTDSum.Project = @parm2 and
	acct = 'Billed To Date'
	end
GO

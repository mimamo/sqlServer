USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xLockedActual]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xLockedActual] 
@parm1 Varchar(1),
@parm2 varchar(16)
as

If @parm1 = 'A' --Toggle Amount
	Begin
	select sum(act_amount) from PJPTDSum , PJACCT where
	PJPTDSum.Project = @parm2
	AND pjptdsum.acct = pjacct.acct
	and (acct_group_cd = 'WP' or acct_group_cd = 'WA')
	End
Else
	Begin --Toggle Units
	select sum(act_Units) from PJPTDSum,PJACCT  where
	PJPTDSum.Project = @parm2
	AND pjptdsum.acct = pjacct.acct
	and (acct_group_cd = 'WP'  or acct_group_cd = 'WA')
End
GO

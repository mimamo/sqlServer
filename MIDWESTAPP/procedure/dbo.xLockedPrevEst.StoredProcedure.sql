USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xLockedPrevEst]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xLockedPrevEst] 
@parm1 Varchar(1),
@parm2 varchar(16),
@parm3 Varchar(4)  --New unbound Current lock estimate pm_id25

as

If @parm1 = 'A' --Toggle Amount
	Begin
	select Sum(Amount) from pjrevcat where
	PJREVCAT.PROJECT = @parm2 
	and PJREVCAT.revid = @parm3   --(pass the previous revision ID from the unbound control on the screen)
	End
Else
	Begin  --Toggle Unit
	select Sum(Units) from pjrevcat where
	PJREVCAT.PROJECT = @parm2 
	and PJREVCAT.revid = @parm3   --(pass the previous revision ID from the unbound control on the screen)
	End
GO

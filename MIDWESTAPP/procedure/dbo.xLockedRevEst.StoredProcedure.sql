USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xLockedRevEst]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xLockedRevEst] 
@parm1 Varchar(1),
@parm2 varchar(16)
as

If @parm1 = 'A' --Toggle Amount
	Begin
	select Sum(Amount) from PJPROJEX,pjrevcat where
	PJPROJEX.Project = @parm2
	and pjrevcat.Project = PJPROJEX.Project
	and pjrevcat.Revid = PJPROJEX.pm_id25
	End
Else
	Begin  --Toggle Units
	select Sum(Units) from PJPROJEX,pjrevcat where
	PJPROJEX.Project = @parm2
	and pjrevcat.Project = PJPROJEX.Project
	and pjrevcat.Revid = PJPROJEX.pm_id25
	End
GO

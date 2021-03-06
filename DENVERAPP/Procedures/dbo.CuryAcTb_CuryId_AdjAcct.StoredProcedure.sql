USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcTb_CuryId_AdjAcct]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[CuryAcTb_CuryId_AdjAcct] @parm1 varchar ( 4), @parm2 varchar ( 10) as
    select *
	from CuryAcTb
		left outer join Account
			on CuryAcTb.AdjAcct = Account.Acct
    where CuryAcTb.CuryID = @parm1
		and AdjAcct like @parm2
    order by CuryAcTb.CuryID, CuryAcTb.AdjAcct
GO

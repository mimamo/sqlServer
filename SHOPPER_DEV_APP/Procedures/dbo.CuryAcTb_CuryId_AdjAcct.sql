USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcTb_CuryId_AdjAcct]    Script Date: 12/16/2015 15:55:15 ******/
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

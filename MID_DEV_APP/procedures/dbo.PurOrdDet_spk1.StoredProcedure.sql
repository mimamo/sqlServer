USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_spk1]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PurOrdDet_spk1] as
select * from PURORDDET, PURCHORD, PJ_ACCOUNT
where    PURORDDET.PONbr   = PURCHORD.PONbr and
PURORDDET.PurAcct = PJ_ACCOUNT.gl_acct and
PURCHORD.POType  in ('OR','BL','DP') and
PURCHORD.Status  in ('P','O','C') and
PURORDDET.User4 = 1
order by PURORDDET.PONbr,
PURORDDET.linenbr
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_stran2]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PurOrdDet_stran2] as
select PURORDDET.*, PURCHORD.POtype, PURCHORD.status, PURCHORD.cpnyid,
    PURCHORD.ponbr, PURCHORD.podate, PURCHORD.vendid, PURCHORD.curyratetype, PURCHORD.CuryEffDate,
    PJ_ACCOUNT.*
from PURORDDET, PURCHORD, PJ_ACCOUNT
where
PURORDDET.pc_status = '1' and
PURORDDET.PONbr   = PURCHORD.PONbr and
PURORDDET.PurAcct = PJ_ACCOUNT.gl_acct and
PURCHORD.POType  in ('OR','BL','DP') and
PURCHORD.status <> 'Q' and
PURCHORD.status <> 'X' and
PURCHORD.status <> 'M'
GO

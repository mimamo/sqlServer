USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Select_PrePay]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
---DCR added 5/21/98
Create Proc [dbo].[Select_PrePay] @parm1 varchar(15), @parm2 varchar(10)as
Select j.* from apadjust j, apdoc d
where j.adjddoctype = d.doctype and
d.refnbr = j.AdjdRefNbr and
j.vendid = d.vendid and
j.adjddoctype = 'PP' and
j.AdjAmt > 0 and
d.docbal <> d.origdocamt and
j.s4future11 <> 'V' and
j.vendid = @parm1 and
j.adjdrefnbr = @parm2
order by j.adjdrefnbr
GO

USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PONbr_On_VO]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PONbr_On_VO    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[PONbr_On_VO]    @parm1 varchar ( 10), @parm2 varchar(10) As
select distinct d.batnbr, d.refnbr
from APDoc d inner join aptran t on t.batnbr = d.batnbr and t.trantype = d.doctype and t.refnbr = d.refnbr
Where t.PONbr = @parm1 and d.RefNBr <> @parm2
and d.rlsed = 0 and d.docclass = 'N' and status <> 'V'
GO

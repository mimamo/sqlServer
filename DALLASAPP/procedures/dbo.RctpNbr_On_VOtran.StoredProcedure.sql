USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RctpNbr_On_VOtran]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RctpNbr_On_VOtran    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[RctpNbr_On_VOtran] @parm1 varchar(10), @parm3 varchar(10) As
select t.batnbr, t.refnbr
from APtran t
inner join potran pt on pt.ponbr = t.ponbr and pt.rcptnbr = t.rcptnbr
inner join poreceipt r on r.rcptnbr = pt.rcptnbr
Where r.rcptnbr = @parm1 and t.RefNBr <> @parm3
and t.rlsed = 0  and t.trantype in ('AD', 'VO')
GO

USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PORcpt_On_VOtran2]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PORcpt_On_VOtran2] @parm1  varchar(10), @parm2 varchar(5), @parm3 float, @parm4 float As
select batnbr, rcptnbr from POtran
where
RcptNbr = @parm1 and
LineRef = @parm2 and
(convert(dec(28,3),@parm3) <> convert(dec(28,3),POTran.CuryExtCost) - convert(dec(28,3),POTran.CuryCostVouched)
OR
convert(dec(25,9),@parm4) <> convert(dec(25,9),POTran.RcptQty) - convert(dec(25,9),POTran.QtyVouched))
GO

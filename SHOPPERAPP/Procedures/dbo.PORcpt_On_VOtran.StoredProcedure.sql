USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PORcpt_On_VOtran]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PORcpt_On_VOtran] @parm1 varchar( 10), @parm2 varchar(10), @parm3 varchar(10), @parm4 varchar(5) As
select batnbr, refnbr from APtran
Where
PONbr = @parm1 and
RcptNbr = @parm2 and
RefNBr <> @parm3 and
rlsed = 0 and
RcptLineRef = @parm4
GO

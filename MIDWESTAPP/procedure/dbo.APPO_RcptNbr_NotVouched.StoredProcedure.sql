USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APPO_RcptNbr_NotVouched]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[APPO_RcptNbr_NotVouched] @parm1 varchar ( 10), @parm2 varchar(10) as
 Select * from POTran where RcptNbr = @parm1 and ponbr like @parm2
    and VouchStage <> 'F'
	and not exists(select 'x' from aptran where
		rcptnbr = @parm1 and
		(ponbr = @parm2 or @parm2='%') and
		APTran.RcptLineRef = POTran.LineRef and
		aptran.rlsed = 0)
            Order by LineNbr
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_LineRef]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[INTran_BatNbr_LineRef]
	@parm1		varchar(10),
	@parm2		varchar(5) as

	Select * from INTran
		Where	Batnbr = @parm1 and
			LineRef = @parm2
    	Order by BatNbr, LineId
GO

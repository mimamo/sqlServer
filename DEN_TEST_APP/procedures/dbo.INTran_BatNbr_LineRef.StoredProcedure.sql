USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_LineRef]    Script Date: 12/21/2015 15:36:57 ******/
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

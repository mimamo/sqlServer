USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_RefNbr_LineID]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APTran_RefNbr_LineID]
	@parm1 varchar ( 10),
	@parm2 varchar ( 3)
as
Select *
from APTran
where Refnbr = @parm1
	and LineID = @parm2
GO

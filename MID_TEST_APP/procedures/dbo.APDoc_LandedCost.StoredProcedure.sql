USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_LandedCost]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APDoc_LandedCost]
	@parmCpnyID varchar (10),
	@parmBatNBr varchar ( 10)
	as
Select * from APDoc Where
	APDoc.BatNbr = @parmBatNbr and
	APDoc.CpnyID = @parmCpnyID and
	APDoc.Rlsed = 1 and
	apdoc.doctype = 'VO'
Order by
	APDoc.BatNbr,
	APDoc.RefNbr
GO

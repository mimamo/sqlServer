USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WorkGL_Sum]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[WorkGL_Sum]
	@BatNbr		Varchar(10),
	@Module		Varchar(2)
As
	Select	BatNbr, Sum(CrAmt) As CrTot, Sum(DrAmt) As DrTot, Count(*) As RecCount
		From	Wrk10400_GLTran
		Where	BatNbr = @BatNbr
			And Module = @Module
		Group By BatNbr
GO

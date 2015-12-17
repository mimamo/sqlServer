USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPeriodLength_All]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRPeriodLength_All] @CpnyID VarChar(10), @SetupID VarChar(2), @LineNbrStart SmallInt, @LineNbrEnd SmallInt AS
Select * from IRPeriodLength
	Where
		CpnyID like @CpnyID And
		SetupID Like @SetupID And
		LineNbr Between @LineNbrStart and @LineNbrEnd
	Order by CpnyID, SetupID, LineNbr
GO

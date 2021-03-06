USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_CuryRate]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_CuryRate]
	@FromCuryID	VarChar(4),
	@ToCuryID	VarChar(4),
	@RateType	VarChar(6),
	@EffDate	SmallDateTime
As
	Select	Top 1
		*
		From	CuryRate (NoLock)
		Where 	FromCuryId = @FromCuryID
			And ToCuryID = @ToCuryID
			And RateType = @RateType
			And EffDate <= @EffDate
		Order By EffDate Desc
GO

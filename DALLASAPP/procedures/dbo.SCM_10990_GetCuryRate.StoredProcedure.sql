USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_GetCuryRate]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[SCM_10990_GetCuryRate]
	@FromCuryID	VarChar(4),
	@ToCuryID	VarChar(4),
	@RateType	VarChar(6),
	@EffDate	SmallDateTime,
	@BMICuryID	VarChar(4),
	@BMIDfltRtTp	VarChar(4)

As
/*
	Retrieve a Currency Record
*/
	Select * From CuryRate
		Where 	FromCuryId = @FromCuryID
            		And ToCuryID = 	Case When RTrim(@ToCuryID) = ''
						Then @BMICuryID
						Else @ToCuryID
					End
            		And RateType = 	Case When RTrim(@RateType) = ''
						Then @BMIDfltRtTp
						Else @RateType
					End
            		And EffDate <= 	Case When Convert(SmallDateTime, @EffDate) = '01/01/1900'
						Then Convert(SmallDateTime, GetDate())
						Else Convert(SmallDateTime, @EffDate)
					End
	Order By EffDate Desc
GO

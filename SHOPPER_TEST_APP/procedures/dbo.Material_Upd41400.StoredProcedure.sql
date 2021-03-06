USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Material_Upd41400]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Material_Upd41400] 	@ReplenMethod VARCHAR(1),
					@FutureReplPol VARCHAR(1),
					@FutureReplDate SmallDateTime,
					@MatlType VARCHAR(10)
 AS
	Update SIMatlTypes set
		ReplMthd = @ReplenMethod,
		IRFuturePolicy = @FutureReplPol,
		IRFutureDate = @FutureReplDate
		WHERE
			MaterialType = @MatlType
GO

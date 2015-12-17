USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Material_Upd41400]    Script Date: 12/16/2015 15:55:25 ******/
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

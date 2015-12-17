USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Site_Upd41400]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Site_Upd41400] 	@ReplenMethod VARCHAR(1),
					@FutureReplPol VARCHAR(1),
					@FutureReplDate SmallDateTime,
					@SiteID VARCHAR(10)
 AS
	Update Site set
		ReplMthd = @ReplenMethod,
		IRFuturePolicy = @FutureReplPol,
		IRFutureDate = @FutureReplDate
		WHERE
			SiteID = @SiteID
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_Upd41400]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Inventory_Upd41400] 	@ReplenMethod VARCHAR(1),
					@FutureReplPol VARCHAR(1),
					@FutureReplDate SmallDateTime,
					@InvtID VARCHAR(30)
 AS
	Update Inventory set
		ReplMthd = @ReplenMethod,
		IRFuturePolicy = @FutureReplPol,
		IRFutureDate = @FutureReplDate
		WHERE
			InvtID = @InvtID
GO

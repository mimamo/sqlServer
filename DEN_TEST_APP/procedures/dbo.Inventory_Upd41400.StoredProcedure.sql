USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_Upd41400]    Script Date: 12/21/2015 15:36:57 ******/
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

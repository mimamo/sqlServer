USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Inventory_Next]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Inventory_Next]
	@InvtID		VarChar(30)
As
	Select	Top 1
		*
		From	Inventory (NoLock)
		Where	InvtID > @InvtID
		Order By InvtID
GO

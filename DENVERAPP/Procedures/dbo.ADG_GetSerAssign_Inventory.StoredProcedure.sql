USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetSerAssign_Inventory]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetSerAssign_Inventory]
	@InvtID		Varchar(30)
As

SELECT	SerAssign, StkItem
	FROM	Inventory (NOLOCK)
	WHERE	InvtID = @InvtID
GO

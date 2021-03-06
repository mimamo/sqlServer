USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_SourceCode_Check]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_ItemSite_SourceCode_Check]
	@CpnyID	VarChar(10),
	@InvtID	VarChar(30),
	@SiteID	VarChar(10)
AS

Declare	@Result	SmallInt

/*
	1 - Purchase Order
	2 - OM Kit Assembly
*/
	Select	@Result =	Case	When	IRSourceCode In ('1','2')
						Then	1
					Else	0
				End
		From	ItemSite (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And CpnyID = @CpnyID

	Select	@Result
GO

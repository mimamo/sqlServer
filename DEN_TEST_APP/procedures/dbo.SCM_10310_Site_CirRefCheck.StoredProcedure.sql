USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10310_Site_CirRefCheck]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10310_Site_CirRefCheck]
	@SiteID			VarChar(10),
	@FromSiteID		VarChar(10)
As
	While	RTrim(@FromSiteID) <> ''
	Begin
		Select	@FromSiteID = IRTransferSiteID
			From	Site (NoLock)
			Where	SiteID = @FromSiteID
				And IRSourceCode = '3'
		/* End of Chain Found */
		If	@@RowCount = 0
			Break

		/* Circular Reference Would Occur */
		If	@FromSiteID = @SiteID
			Break
	End

	If	@FromSiteID = @SiteID
		Select	Cast(0 As SmallInt)
	Else
		Select	Cast(1 As SmallInt)
GO

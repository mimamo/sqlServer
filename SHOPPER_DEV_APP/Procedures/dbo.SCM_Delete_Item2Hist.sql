USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Delete_Item2Hist]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Delete_Item2Hist]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@LockYear	Char(4)
As
	If	RTrim(@LockYear) = ''
	Begin
		Set	@LockYear = '1900'
	End
	Delete	From	Item2Hist
		Where	FiscYr > @LockYear
			And InvtID =	Case 	When 	RTrim(@InvtID) <> ''
							Then	@InvtID
						Else	InvtID
					End
			And SiteID =	Case 	When 	RTrim(@SiteID) <> ''
							Then	@SiteID
						Else	SiteID
					End
GO

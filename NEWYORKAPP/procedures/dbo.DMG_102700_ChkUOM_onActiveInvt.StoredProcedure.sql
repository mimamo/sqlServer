USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_102700_ChkUOM_onActiveInvt]    Script Date: 12/21/2015 16:00:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_102700_ChkUOM_onActiveInvt]
	/*Begin Parameters)*/
	@FromUnit varchar(6)
	/*En Parameters*/
as
Select * from Inventory where DfltPOUnit = @FromUnit or
                              DfltSOUnit = @FromUnit or
			      StkUnit = @FromUnit

Order by Invtid
GO

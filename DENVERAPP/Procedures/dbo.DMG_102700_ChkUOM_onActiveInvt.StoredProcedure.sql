USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_102700_ChkUOM_onActiveInvt]    Script Date: 12/21/2015 15:42:46 ******/
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

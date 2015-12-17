USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_102700_ChkUOM_onActiveInvt]    Script Date: 12/16/2015 15:55:16 ******/
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

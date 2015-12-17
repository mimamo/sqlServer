USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Site_Blank_CpnyID]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[SCM_10990_Site_Blank_CpnyID]
As
/*
	This procedure will return a record set containing invalid data found in the Site
	table.  Each occurance of invalid data will be returned as a row in the result set.
*/
	Set	NoCount On

/*	Site records cannot have a blank CpnyID. */
	Select	* From	Site
		Where	RTrim(CpnyID) = ''
GO

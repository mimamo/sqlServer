USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOLocTable_SiteID_InvtID_Prd]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLocTable_SiteID_InvtID_Prd]
	@Parm1		varchar(10),
	@Parm2		varchar(30),
	@Parm3		varchar(10)
As
	SELECT		*
	FROM		LocTable
	WHERE		LocTable.SiteID = @parm1 and
			LocTable.WOProdValid In ('Y','W') and
			((LocTable.InvtIDValid = 'Y' and LocTable.InvtID = @parm2) or
			LocTable.InvtIDValid = 'W' or
			LocTable.InvtIDValid = 'N' or
			LocTable.InvtID = '') and
			WhseLoc like @parm3
	ORDER BY	SiteID, InvtID, WhseLoc
GO

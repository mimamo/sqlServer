USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOLocTable_SiteID_InvtID_Iss]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLocTable_SiteID_InvtID_Iss]
	@Parm1		varchar(10),
	@Parm2		varchar(30),
	@Parm3		varchar(30),
	@Parm4		varchar(30),
	@Parm5		varchar(10)

As
	SELECT		location.*
	FROM		Loctable LT,location
	WHERE		LT.siteid = @parm1 and
			LT.WOIssueValid <> 'N' and
			((LT.InvtIDValid = 'Y' and LT.InvtID = @parm2 and Location.invtid = @parm3) or
			(LT.InvtIDValid <> 'Y' and Location.invtid = @parm4)) and
			LT.whseloc like @parm5 and
			LT.siteid = Location.siteid and
			LT.whseloc = Location.whseloc
	ORDER BY	LT.WhseLoc
GO

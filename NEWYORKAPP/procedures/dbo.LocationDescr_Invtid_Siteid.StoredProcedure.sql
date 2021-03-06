USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LocationDescr_Invtid_Siteid]    Script Date: 12/21/2015 16:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LocationDescr_Invtid_Siteid]
	@parm1 varchar ( 30),
	@parm2 varchar ( 10) AS
SELECT *
	FROM location
		left outer join LocTable
			on Location.SiteID = Loctable.SiteID
			and Location.WhseLoc = Loctable.WhseLoc
	WHERE Location.Invtid = @parm1 AND
		Location.siteid like @parm2
	ORDER BY
         Location.invtid,  Location.siteid,  Location.whseloc
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_CpnySiteId_Status]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_CpnySiteId_Status] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4 varchar (10) as
	Select k.* from Kit k
		JOIN Site s on k.SiteID = s.SiteId
        where k.KitId = @parm1
		and k.SiteID = @parm2
		and k.Status = @parm3
		and s.CpnyID = @parm4
		order by k.KitId, k.SiteID, k.Status
GO

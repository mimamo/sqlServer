USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_SiteID_WhseLoc_Delete]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Location_SiteID_WhseLoc_Delete] @parm1 varchar(10), @parm2 varchar(10) as
delete from Location
where 	SiteID = @parm1 and
	WhseLoc = @parm2
GO

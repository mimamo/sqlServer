USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_SiteId_Status]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_SiteId_Status] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1) as
            Select * from Kit where KitId = @parm1
		and siteid = @parm2 and
		status = @parm3
                order by KitId, siteid, status
GO

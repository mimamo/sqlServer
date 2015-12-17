USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_SiteId_Status]    Script Date: 12/16/2015 15:55:24 ******/
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

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WorkCenter_WorkCenterId_Site]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WorkCenter_WorkCenterId_Site] @parm1 varchar ( 10), @parm2 varchar ( 10) as
            Select * from WorkCenter where WorkCenterId = @parm1 And SiteId = @parm2
                order by WorkCenterId, Siteid
GO

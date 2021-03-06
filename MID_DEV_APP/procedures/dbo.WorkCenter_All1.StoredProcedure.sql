USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WorkCenter_All1]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WorkCenter_All1] @parm1 varchar ( 10) as
       SELECT *
         FROM WorkCenter
        WHERE WorkCenterId like @parm1
          AND (PFLbrOvhRate <> 0 OR PFMachOvhRate <> 0 OR PLbrOvhRate <> 0
               OR PMachOvhRate <> 0 OR PVLbrOvhRate <> 0 OR PVMachOvhRate <> 0)
        ORDER BY WorkCenterId
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WorkCenter_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WorkCenter_All] @parm1 varchar ( 10) as
            Select * from WorkCenter where WorkCenterId like @parm1
                order by WorkCenterId
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WorkCenter_All]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WorkCenter_All] @parm1 varchar ( 10) as
            Select * from WorkCenter where WorkCenterId like @parm1
                order by WorkCenterId
GO

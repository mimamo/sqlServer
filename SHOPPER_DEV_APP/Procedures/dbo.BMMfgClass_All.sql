USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMMfgClass_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMMfgClass_All] @parm1 varchar ( 10) as
            Select * from BMMfgClass where MfgClassId like @parm1
                order by MfgClassId
GO

USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Picycle_All]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Picycle_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Picycle_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Picycle_All] @parm1 varchar ( 10) as
            Select * from picycle where CycleID like @parm1
                order by CycleID
GO

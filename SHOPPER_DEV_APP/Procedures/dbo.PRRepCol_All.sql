USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRRepCol_All]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRRepCol_All] @parm1 varchar ( 30) as
       Select * from PRRepCol
           where ReportName LIKE @parm1
           order by ReportName
GO

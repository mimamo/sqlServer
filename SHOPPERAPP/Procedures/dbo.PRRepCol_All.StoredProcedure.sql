USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRRepCol_All]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRRepCol_All] @parm1 varchar ( 30) as
       Select * from PRRepCol
           where ReportName LIKE @parm1
           order by ReportName
GO

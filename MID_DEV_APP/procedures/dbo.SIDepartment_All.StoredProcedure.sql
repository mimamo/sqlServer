USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SIDepartment_All]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIDepartment_All    Script Date: 4/7/98 12:42:26 PM ******/
/****** Object:  Stored Procedure dbo.SIDepartment_All    Script Date: 12/17/97 10:49:00 AM ******/
Create Procedure [dbo].[SIDepartment_All] @Parm1 Varchar(10) as
Select * from SIDepartment WHERE DeptID LIKE @Parm1 Order by DeptID
GO

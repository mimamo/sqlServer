USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PODeptAssg_UserID_All]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PODeptAssg_UserID_All    Script Date: 12/17/97 10:48:59 AM ******/
CREATE Procedure [dbo].[PODeptAssg_UserID_All] @Parm1 Varchar(47), @Parm2 Varchar(10) As
Select SIDepartment.* From SIDepartment, SIDeptAssign WHERE SIDepartment.DeptID = SIDeptAssign.DeptID and SIDeptAssign.UserID = @Parm1
and SIDepartment.DeptID LIKE @Parm2 Order By SIDepartment.DeptID
GO

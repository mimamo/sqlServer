USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SIDeptAssign_DBnav]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIDeptAssign_DBnav    Script Date: 4/7/98 12:42:26 PM ******/
/****** Object:  Stored Procedure dbo.SIDeptAssign_DBnav    Script Date: 12/17/97 10:48:27 AM ******/
Create Procedure [dbo].[SIDeptAssign_DBnav] @Parm1 Varchar(10), @parm2 Varchar(47) as
Select * from SIDeptAssign  where DeptID  = @parm1 and UserID LIKE @parm2
order by DeptID, UserID
GO

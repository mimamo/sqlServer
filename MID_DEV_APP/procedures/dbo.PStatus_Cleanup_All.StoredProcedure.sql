USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PStatus_Cleanup_All]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PStatus_Cleanup_All    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.PStatus_Cleanup_All    Script Date: 4/7/98 12:56:04 PM ******/
Create Proc  [dbo].[PStatus_Cleanup_All] @parm1 varchar ( 21) as
Update PStatus set Status = 'I'
WHERE InternetAddress   like @parm1
AND   Status            = 'S'
GO

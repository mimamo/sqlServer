USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PStatus_Cleanup]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PStatus_Cleanup    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.PStatus_Cleanup    Script Date: 4/7/98 12:56:04 PM ******/
Create Proc  [dbo].[PStatus_Cleanup] @parm1 varchar ( 21), @parm2 smallint as
Update PStatus set Status = 'I'
WHERE InternetAddress   like @parm1
AND   SessionCntr       =    @parm2
AND   Status            = 'S'
GO

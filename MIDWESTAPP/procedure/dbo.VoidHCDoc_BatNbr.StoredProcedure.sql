USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[VoidHCDoc_BatNbr]    Script Date: 12/21/2015 15:55:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.VoidHCDoc_BatNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[VoidHCDoc_BatNbr] @parm1 varchar ( 10) As
Delete apdoc from APDoc Where BatNbr = @parm1
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FSTrslHd_Delete]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FSTrslHd_Delete    Script Date: 4/7/98 12:45:04 PM ******/
Create Procedure [dbo].[FSTrslHd_Delete] @parm1 varchar ( 6) as
     Select * from FSTrslHd where PerPost <= @parm1 and PerPost <> ' '
     Order by PerPost, RefNbr
GO

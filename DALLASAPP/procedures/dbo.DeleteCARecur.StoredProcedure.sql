USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCARecur]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCARecur    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCARecur] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Delete From CARecur Where
CARecur.RecurID = @parm1
and cpnyid like @parm2
GO

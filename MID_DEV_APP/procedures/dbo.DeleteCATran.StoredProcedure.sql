USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCATran]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCATran    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCATran] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Delete From CATran Where
CATran.RecurID = @parm1
and @parm2 like cpnyid
GO

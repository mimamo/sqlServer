USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_DelForAccessNbr]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDWrkContPrint_DelForAccessNbr]
	@AccessNbr Integer
As
Delete From EDWrkContPrint Where AccessNbr = @AccessNbr
GO

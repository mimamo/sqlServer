USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_DelForAccessNbr]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDWrkContPrint_DelForAccessNbr]
	@AccessNbr Integer
As
Delete From EDWrkContPrint Where AccessNbr = @AccessNbr
GO

USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_Clear]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkPOToSO_Clear] @AccessNbr smallint As
Delete From EDWrkPOToSO Where AccessNbr = @AccessNbr
GO

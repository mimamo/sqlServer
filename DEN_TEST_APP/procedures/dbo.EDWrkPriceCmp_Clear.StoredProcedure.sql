USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPriceCmp_Clear]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkPriceCmp_Clear] @ComputerName VarChar(21) As
Delete From EDWrkPriceCmp Where ComputerId = @ComputerName
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPriceCmp_Clear]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkPriceCmp_Clear] @ComputerName VarChar(21) As
Delete From EDWrkPriceCmp Where ComputerId = @ComputerName
GO

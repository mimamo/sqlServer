USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_Purge]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_Purge] As
Delete From EDSOHeader Where Not Exists (Select * From SOHeader Where EDSOHeader.CpnyId =
SOHeader.CpnyId And EDSOHeader.OrdNbr = SOHeader.OrdNbr)
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_Purge]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_Purge] As
Delete From EDSOHeader Where Not Exists (Select * From SOHeader Where EDSOHeader.CpnyId =
SOHeader.CpnyId And EDSOHeader.OrdNbr = SOHeader.OrdNbr)
GO

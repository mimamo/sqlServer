USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_FunctionClass]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_FunctionClass] @FunctionId varchar(8), @ClassId varchar(4) As
Select CpnyId, OrdNbr From SOHeader Where NextFunctionId = @FunctionId And NextFunctionClass = @ClassId
GO

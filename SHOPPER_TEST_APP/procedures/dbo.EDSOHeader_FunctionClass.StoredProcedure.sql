USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_FunctionClass]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_FunctionClass] @FunctionId varchar(8), @ClassId varchar(4) As
Select CpnyId, OrdNbr From SOHeader Where NextFunctionId = @FunctionId And NextFunctionClass = @ClassId
GO

USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDFOBPoint_GetId]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDFOBPoint_GetId] @Descr varchar(30) As
Select FOBID From FOBPoint Where Descr = @Descr
GO

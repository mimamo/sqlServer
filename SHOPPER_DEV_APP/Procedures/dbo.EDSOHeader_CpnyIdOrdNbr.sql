USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_CpnyIdOrdNbr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_CpnyIdOrdNbr] @CpnyId varchar(10), @OrdNbr varchar(15) As
Select * From EDSOHeader Where CpnyId = @CpnyId And OrdNbr = @OrdNbr
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_CustId]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_CustId] @CpnyId varchar(10), @OrdNbr varchar(15) As
Select CustId From SOHeader Where CpnyId = @CpnyId And OrdNbr = @OrdNbr
GO

USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_PPCtnsOnTare]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_PPCtnsOnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select Count(*) From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareId = @TareId And PackMethod = 'PP'
GO

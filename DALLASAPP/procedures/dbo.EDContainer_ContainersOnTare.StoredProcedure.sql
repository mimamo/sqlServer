USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_ContainersOnTare]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_ContainersOnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareId = @TareId
GO

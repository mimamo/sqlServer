USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_OnTare]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_OnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareId = @TareId Order By CpnyId, ShipperId, ContainerId
GO

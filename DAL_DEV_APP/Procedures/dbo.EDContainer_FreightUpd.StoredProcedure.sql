USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_FreightUpd]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_FreightUpd] @CpnyId varchar(10), @ShipperId varchar(15), @ShpCharge float, @CuryShpCharge float As
Update EDContainer Set ShpCharge = @ShpCharge, CuryShpCharge = @CuryShpCharge Where CpnyId = @CpnyId And ShipperId = @ShipperId And ContainerId =
(Select Max(ContainerId) From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId)
GO

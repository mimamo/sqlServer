USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_RemoveFromTare]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_RemoveFromTare] @TareId varchar(10), @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDContainer Set TareId = ' ' Where TareId = @TareId  And CpnyId = @CpnyId  And ShipperId = @ShipperId
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UpdtTareId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_UpdtTareId] @CpnyId varchar(10), @ContainerId varchar(10), @TareId varchar(10) As
Update EDContainer Set TareId = @TareId Where CpnyId = @CpnyId And ContainerId = @ContainerId
GO

USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UpdtTareId]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_UpdtTareId] @CpnyId varchar(10), @ContainerId varchar(10), @TareId varchar(10) As
Update EDContainer Set TareId = @TareId Where CpnyId = @CpnyId And ContainerId = @ContainerId
GO

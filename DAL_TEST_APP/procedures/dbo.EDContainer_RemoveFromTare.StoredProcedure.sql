USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_RemoveFromTare]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_RemoveFromTare] @TareId varchar(10), @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDContainer Set TareId = ' ' Where TareId = @TareId  And CpnyId = @CpnyId  And ShipperId = @ShipperId
GO

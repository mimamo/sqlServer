USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_EmptyTares]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_EmptyTares] @CpnyId varchar(10), @ShipperId varchar(15) As
Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And
TareFlag = 1 And ContainerId Not In (Select Distinct TareId From EDContainer Where
CpnyId = @CpnyId And ShipperId = @ShipperId)
GO

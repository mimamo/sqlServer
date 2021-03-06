USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_CountContainerTare]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_CountContainerTare] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Cast(Sum(Case TareFlag When 1 Then 0 Else 1 End) As int),
Cast(Sum(Case TareFlag When 1 Then 1 Else 0 End) As int)
From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO

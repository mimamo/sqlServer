USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_CountContainersOnTare]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_CountContainersOnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select Cast(Sum(Case PackMethod When 'PP' Then 1 Else 0 End) As int), Count(*)
From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareId = @TareId
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_HeaderDetail]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_HeaderDetail] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From EDContainer A Left Outer Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperId =
B.ShipperId And A.ContainerId = B.ContainerId Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId
Order By A.ContainerId
GO

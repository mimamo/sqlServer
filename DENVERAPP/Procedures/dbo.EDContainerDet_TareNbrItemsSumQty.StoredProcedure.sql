USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_TareNbrItemsSumQty]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_TareNbrItemsSumQty] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select Count(Distinct B.InvtId), Count(Distinct B.UOM), Sum(B.QtyShipped), Count(Distinct A.ContainerId)
From EDContainer A Inner Join EDContainerDet B On A.ContainerId = B.ContainerId Where A.CpnyId = @CpnyId And
A.ShipperId = @ShipperId And A.TareId = @TareId
GO

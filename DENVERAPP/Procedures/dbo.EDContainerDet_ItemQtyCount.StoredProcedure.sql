USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ItemQtyCount]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_ItemQtyCount] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select 	Count(Distinct InvtId),
	Count(Distinct A.QtyShipped),
	Count(Distinct A.ContainerId),
	Count(*),
	Max(A.InvtId),
	Max(A.QtyShipped)
From EDContainerDet A Inner Join EDContainer B On
	A.CpnyId = B.CpnyId And
	A.ShipperId = B.ShipperId And
	A.ContainerId = B.ContainerId
Where A.CpnyId = @CpnyId And
	A.ShipperId = @ShipperId And
	B.TareId = @TareId
GO

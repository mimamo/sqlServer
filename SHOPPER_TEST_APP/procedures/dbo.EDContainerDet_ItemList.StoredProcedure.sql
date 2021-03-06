USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ItemList]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_ItemList] @CpnyId varchar(10), @ShipperId varchar(15) As
Select *
From EDContainer
	left outer join EDContainerDet
		on EDContainer.ContainerId = EDContainerDet.ContainerId
Where EDContainer.CpnyId = @CpnyId And
	EDContainer.ShipperId = @ShipperId And
	EDContainer.TareFlag = 0
Order By EDContainerDet.InvtId,EDContainer.TareId,EDContainerDet.ContainerId
GO

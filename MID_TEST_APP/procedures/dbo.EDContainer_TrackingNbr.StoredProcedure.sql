USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TrackingNbr]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_TrackingNbr] @TrackingNbr varchar(30) As
Select * From EDContainer A WITH(Index(EDContainer2)) Left Outer Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperId =
B.ShipperId And A.ContainerId = B.ContainerId Where A.TrackingNbr = @TrackingNbr Order By A.ContainerId
GO

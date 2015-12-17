USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UCC128Detail]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_UCC128Detail] @UCC128 varchar(20) As
Select * From EDContainer A With(Index(EDContainer3)) Left Outer Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperId =
B.ShipperId And A.ContainerId = B.ContainerId Where A.UCC128 = @UCC128 Order By A.ContainerId
GO

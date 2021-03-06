USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UCC128Detail]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_UCC128Detail] @UCC128 varchar(20) As
Select * From EDContainer A With(Index(EDContainer3)) Left Outer Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperId =
B.ShipperId And A.ContainerId = B.ContainerId Where A.UCC128 = @UCC128 Order By A.ContainerId
GO

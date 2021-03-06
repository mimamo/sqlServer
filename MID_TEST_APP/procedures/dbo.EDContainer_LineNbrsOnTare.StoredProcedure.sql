USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_LineNbrsOnTare]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_LineNbrsOnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select A.ContainerId, B.InvtId, B.LineNbr From EDContainer A Inner Join EDContainerDet B On A.CpnyId =
B.CpnyId And A.ShipperId = B.ShipperId And A.ContainerId = B.ContainerId Where A.CpnyId = @CpnyId
And A.ShipperId = @ShipperId And A.TareId = @TareId
GO

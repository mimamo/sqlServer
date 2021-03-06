USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_NoLabel]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDContainer_NoLabel] @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.* From EDContainer A Left Outer Join EDContainerDet B On A.ContainerId = B.ContainerId Where
A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.LabelLastPrinted = '01-01-1900' And
(B.LineRef Is Null Or B.LineRef = (Select Min(LineRef) From EDContainerDet C Where C.ContainerId = A.ContainerId)) Order
By A.CpnyId, A.ShipperId, A.ContainerId , B.LineRef
GO

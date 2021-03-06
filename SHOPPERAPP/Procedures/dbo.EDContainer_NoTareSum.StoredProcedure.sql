USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_NoTareSum]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_NoTareSum] @CpnyId varchar(10), @ShipperId varchar (15), @LineRef varchar(5) As
Select Sum(B.QtyShipped) From EDContainer A, EDContainerDet B Where A.CpnyId = @CpnyId And
  A.ShipperId = @ShipperId And LTrim(RTrim(A.TareId)) = '' And A.ContainerId = B.ContainerId
  And B.LineRef = @LineRef
GO

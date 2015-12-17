USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TareSum]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_TareSum] @CpnyId varchar(10), @ShipperId varchar(15),  @TareId varchar (10), @LineRef varchar(5)  As
Select Sum(B.QtyShipped) From EDContainer A Inner Join EDContainerDet B On A.ContainerId =
  B.ContainerId Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.TareId = @TareId And
  B.LineRef = @LineRef
GO

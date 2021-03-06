USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TareSum]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_TareSum] @CpnyId varchar(10), @ShipperId varchar(15),  @TareId varchar (10), @LineRef varchar(5)  As
Select Sum(B.QtyShipped) From EDContainer A Inner Join EDContainerDet B On A.ContainerId =
  B.ContainerId Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.TareId = @TareId And
  B.LineRef = @LineRef
GO

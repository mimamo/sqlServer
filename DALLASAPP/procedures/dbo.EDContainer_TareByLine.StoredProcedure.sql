USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TareByLine]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_TareByLine] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Select A.*,B.LineRef From EDContainer A Inner Join EDContainerDet B On A.ContainerId = B.ContainerId Where
  A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.TareId = @TareId
GO

USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetUnTared]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_GetUnTared] @CpnyId varchar(10), @ShipperId varchar(15) As
Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag = 0 And TareId = ' ' Order By CpnyId, ShipperId, ContainerId
GO

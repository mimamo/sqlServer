USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetTared]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_GetTared] @CpnyId varchar(10), @ShipperId varchar(15) As
Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag = 1
GO

USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetCpnyShipper]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_GetCpnyShipper] @ContainerId varchar(10) As
Select CpnyId, ShipperId From EDContainer Where ContainerId = @ContainerId
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetCpnyShipper]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_GetCpnyShipper] @ContainerId varchar(10) As
Select CpnyId, ShipperId From EDContainer Where ContainerId = @ContainerId
GO

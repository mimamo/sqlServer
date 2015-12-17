USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Count_Shipperid]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_Count_Shipperid] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*)
From EDContainer
Where  CpnyId = @CpnyId And ShipperId = @ShipperId
GO

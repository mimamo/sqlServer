USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDSOShipHeader_all    Script Date: 5/28/99 1:17:45 PM ******/
CREATE PROCEDURE [dbo].[EDSOShipHeader_AllDMG] @ShipperId varchar( 15 ), @CpnyId varchar( 10 ) AS
Select * From EDSOShipHeader Where CpnyId = @Cpnyid
and ShipperId = @ShipperId
GO

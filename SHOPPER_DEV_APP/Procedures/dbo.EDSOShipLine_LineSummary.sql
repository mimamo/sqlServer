USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_LineSummary]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipLine_LineSummary] @Parm1 varchar( 10 ), @Parm2 varchar( 15 ) AS
Select count(*),sum(qtyship) From SOShipLine Where CpnyId = @parm1
and ShipperId = @Parm2
GO

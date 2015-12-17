USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipline_All]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipline_All]  @Parm1 varchar(10),@parm2 varchar(15) as Select * from SOShipLine where cpnyid like @parm1 and shipperid like @parm2 order by cpnyid,shipperid
GO

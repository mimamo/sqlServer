USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipheader_Shipper_CpnyID]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipheader_Shipper_CpnyID] @parm1 varchar(15), @parm2 varchar(10) AS
select * From edsoshipheader
where shipperid = @parm1 and cpnyid = @Parm2
order by shipperid, cpnyid
GO

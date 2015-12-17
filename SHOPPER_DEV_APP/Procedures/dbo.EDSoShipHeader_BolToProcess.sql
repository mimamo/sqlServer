USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSoShipHeader_BolToProcess]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSoShipHeader_BolToProcess] @parm1 varchar(20) AS
select soshipheader.* from soshipheader,edshipticket where edshipticket.bolnbr = @parm1 and edshipticket.shipperid = soshipheader.shipperid and edshipticket.cpnyid = soshipheader.cpnyid
GO

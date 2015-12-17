USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Update_BolNbr]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_Update_BolNbr] @BolNbr varchar(20), @ShipperID varchar(15), @CpnyID varchar(10)  AS

update EDContainer set bolnbr = @BolNbr where ShipperID = @ShipperID and CpnyID = @CpnyID
GO

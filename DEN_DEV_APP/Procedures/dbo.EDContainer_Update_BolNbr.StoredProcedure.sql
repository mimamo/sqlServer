USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Update_BolNbr]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_Update_BolNbr] @BolNbr varchar(20), @ShipperID varchar(15), @CpnyID varchar(10)  AS

update EDContainer set bolnbr = @BolNbr where ShipperID = @ShipperID and CpnyID = @CpnyID
GO

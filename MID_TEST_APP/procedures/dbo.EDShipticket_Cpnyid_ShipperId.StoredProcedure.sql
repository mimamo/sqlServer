USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipticket_Cpnyid_ShipperId]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipticket_Cpnyid_ShipperId]  @parm1 varchar(10),@parm2 varchar(15) AS
Select * from EDshipTicket Where
Cpnyid like @parm1 and ShipperID like @parm2
GO

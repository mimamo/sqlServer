USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipPayments_Created]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOShipPayments_Created] 
     @ShipRegisterID varchar(10) 
     
as
	Update SOShipPayments 
        Set S4future01 = '1'
	where S4Future11 = @ShipRegisterID
GO

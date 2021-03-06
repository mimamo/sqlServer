USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbr_AddrCustomer]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OrdNbr_AddrCustomer]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@CustID varchar(15)
AS
	select	distinct Customer.*
	from	Customer
	join	SOSched ON SOSched.ShipCustID = Customer.CustID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	Customer.CustID like @CustID
	order by Customer.CustID
GO

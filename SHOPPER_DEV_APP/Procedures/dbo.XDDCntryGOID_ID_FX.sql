USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCntryGOID_ID_FX]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCntryGOID_ID_FX]
	@CpnyID		varchar( 10 ),
	@Acct 		varchar( 10 ),
	@Sub 		varchar( 24 ),
	@ISOCntry		varchar( 2 )
AS
  	Select 		GatewayOperID, DestCntryCuryID, FXIndicator
  	from 		XDDCntryGOID (nolock)
  	where 		CpnyID = @CpnyID
  				and Acct = @Acct
  				and Sub = @Sub
  				and ISOCntry = @ISOCntry
GO
